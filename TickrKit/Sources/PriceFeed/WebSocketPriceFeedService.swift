//
//  WebSocketPriceFeedService.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Foundation
import Domain
import Networking

public actor WebSocketPriceFeedService: PriceFeedService {

    public nonisolated let updates: AsyncStream<PriceUpdate>
    public nonisolated let connectionStates: AsyncStream<ConnectionState>

    private let updatesContinuation: AsyncStream<PriceUpdate>.Continuation
    private let stateContinuation: AsyncStream<ConnectionState>.Continuation

    private let client: WebSocketClient
    private let generator: PriceGenerator
    private let catalog: SymbolCatalog
    private let interval: Duration

    private var prices: [String: Decimal] = [:]
    private var feedTask: Task<Void, Never>?

    public init(
        client: WebSocketClient,
        generator: PriceGenerator = RandomPriceGenerator(),
        catalog: SymbolCatalog = .standard,
        interval: Duration = .seconds(2)
    ) {
        self.client = client
        self.generator = generator
        self.catalog = catalog
        self.interval = interval

        (updates, updatesContinuation) = AsyncStream.makeStream(of: PriceUpdate.self)
        (connectionStates, stateContinuation) = AsyncStream.makeStream(
            of: ConnectionState.self,
            bufferingPolicy: .bufferingNewest(1)
        )
    }

    // MARK: - Lifecycle

    public func start() {
        guard feedTask == nil else { return }
        stateContinuation.yield(.connecting)
        feedTask = Task { await run() }
    }

    public func stop() async {
        guard let feedTask else { return }
        feedTask.cancel()
        await feedTask.value
    }

    private func run() async {
        do {
            let messages = try await client.connect()
            stateContinuation.yield(.connected)

            try await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask { try await self.sendLoop() }
                group.addTask { try await self.receiveLoop(messages) }
                try await group.next()
                group.cancelAll()
            }
        } catch {
            // Connection failed, socket closed, or feed was stopped.
        }

        await client.disconnect()
        stateContinuation.yield(.disconnected)
        feedTask = nil
    }

    // MARK: - Loops

    private func sendLoop() async throws {
        while !Task.isCancelled {
            for entry in catalog.entries {
                let ticker = entry.symbol.ticker
                let current = prices[ticker, default: entry.initialPrice]

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

    private func receiveLoop(_ messages: AsyncThrowingStream<String, Error>) async throws {
        for try await text in messages {
            guard let update = try? PriceMessageCoder.decode(text) else {
                continue
            }
            prices[update.ticker] = update.price
            updatesContinuation.yield(update)
        }
    }
}
