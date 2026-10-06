//
//  WebSocketPriceFeedService.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Foundation
import Domain
import Networking

/// Simulates a live price feed using an echo WebSocket server.
///
/// Every `interval`, a new random price is sent for each symbol.
/// The server echoes each message back, and the echoed prices
/// are what we publish on `updates`.
public actor WebSocketPriceFeedService: PriceFeedService {

    public nonisolated let updates: AsyncStream<PriceUpdate>
    public nonisolated let connectionStates: AsyncStream<ConnectionState>

    private let updatesContinuation: AsyncStream<PriceUpdate>.Continuation
    private let stateContinuation: AsyncStream<ConnectionState>.Continuation

    private let client: WebSocketClient
    private let generator: RandomPriceGenerator
    private let catalog: SymbolCatalog
    private let interval: Duration

    /// Latest price per ticker, so each new random price builds on the last one.
    private var prices: [String: Decimal] = [:]
    private var feedTask: Task<Void, Never>?

    public init(
        client: WebSocketClient,
        generator: RandomPriceGenerator = RandomPriceGenerator(),
        catalog: SymbolCatalog = .standard,
        interval: Duration = .seconds(2)
    ) {
        self.client = client
        self.generator = generator
        self.catalog = catalog
        self.interval = interval

        (updates, updatesContinuation) = AsyncStream.makeStream(of: PriceUpdate.self)
        (connectionStates, stateContinuation) = AsyncStream.makeStream(of: ConnectionState.self)
    }

    /// Convenience for the app: connects to `url` with the default WebSocket client.
    public init(url: URL, catalog: SymbolCatalog = .standard) {
        self.init(client: URLSessionWebSocketClient(url: url), catalog: catalog)
    }

    public func start() {
        guard feedTask == nil else { return }
        feedTask = Task { await run() }
    }

    public func stop() async {
        // Closing the socket ends the receive loop in `run()`.
        feedTask?.cancel()
        await client.disconnect()
        await feedTask?.value
    }

    private func run() async {
        stateContinuation.yield(.connecting)

        do {
            let messages = try await client.connect()
            stateContinuation.yield(.connected)

            // Send prices in the background while we read the echoes here.
            let sendTask = Task { try await sendPrices() }
            defer { sendTask.cancel() }

            for try await text in messages {
                guard let update = try? PriceMessageCoder.decode(text) else {
                    continue   // ignore anything that isn't a price update
                }
                prices[update.ticker] = update.price
                updatesContinuation.yield(update)
            }
        } catch {
            // Connection failed/dropped. reporting it as disconnected below.
        }

        await client.disconnect()
        stateContinuation.yield(.disconnected)
        feedTask = nil
    }

    private func sendPrices() async throws {
        while !Task.isCancelled {
            for entry in catalog.entries {
                let ticker = entry.symbol.ticker
                let current = prices[ticker] ?? entry.initialPrice

                let update = PriceUpdate(
                    ticker: ticker,
                    price: generator.nextPrice(after: current),
                    timestamp: .now
                )
                try await client.send(PriceMessageCoder.encode(update))
            }
            try await Task.sleep(for: interval)
        }
    }
}
