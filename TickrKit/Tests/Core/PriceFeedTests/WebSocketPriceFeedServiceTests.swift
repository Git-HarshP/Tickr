//
//  WebSocketPriceFeedServiceTests.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Testing
import Foundation
import Domain
import Networking
import PriceFeed

@Suite("WebSocketPriceFeedService")
struct WebSocketPriceFeedServiceTests {

    private let catalog = SymbolCatalog(entries: [
        .init(
            symbol: StockSymbol(ticker: "AAPL", name: "Apple", description: "Test"),
            initialPrice: 100
        )
    ])

    @Test("Echoed prices are published as updates")
    func publishesEchoedPrices() async {
        let service = WebSocketPriceFeedService(
            client: EchoWebSocketClient(),
            catalog: catalog,
            interval: .milliseconds(10)
        )

        await service.start()

        var firstUpdate: PriceUpdate?
        for await update in service.updates {
            firstUpdate = update
            break
        }
        await service.stop()

        #expect(firstUpdate?.ticker == "AAPL")
    }

    @Test("Reports connecting, connected, then disconnected after stop")
    func connectionStates() async {
        let service = WebSocketPriceFeedService(client: EchoWebSocketClient(), catalog: catalog)

        await service.start()
        let states = await firstStates(of: service, count: 2)
        await service.stop()
        let finalState = await firstStates(of: service, count: 1)

        #expect(states == [.connecting, .connected])
        #expect(finalState == [.disconnected])
    }

    @Test("A failed connection ends as disconnected")
    func failedConnection() async {
        let service = WebSocketPriceFeedService(client: FailingWebSocketClient(), catalog: catalog)

        await service.start()

        #expect(await firstStates(of: service, count: 2) == [.connecting, .disconnected])
    }

    private func firstStates(of service: WebSocketPriceFeedService, count: Int) async -> [ConnectionState] {
        var states: [ConnectionState] = []
        for await state in service.connectionStates {
            states.append(state)
            if states.count == count { break }
        }
        return states
    }
}

// MARK: - Fake clients

/// Sends every message straight back, like the real echo server.
private actor EchoWebSocketClient: WebSocketClient {
    private var continuation: AsyncThrowingStream<String, Error>.Continuation?

    func connect() async throws -> AsyncThrowingStream<String, Error> {
        let (stream, continuation) = AsyncThrowingStream.makeStream(of: String.self)
        self.continuation = continuation
        return stream
    }

    func send(_ message: String) async throws {
        continuation?.yield(message)
    }

    func disconnect() {
        continuation?.finish()
        continuation = nil
    }
}

/// Always fails to connect.
private struct FailingWebSocketClient: WebSocketClient {
    func connect() async throws -> AsyncThrowingStream<String, Error> {
        throw WebSocketError.connectionFailed
    }

    func send(_ message: String) async throws {}

    func disconnect() async {}
}
