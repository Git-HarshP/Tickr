//
//  SymbolListViewModelTests.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Testing
import Foundation
import Domain
import PriceFeed
@testable import SymbolListFeature

@Suite("SymbolListViewModel")
@MainActor
struct SymbolListViewModelTests {

    private let catalog = SymbolCatalog(entries: [
        .init(symbol: StockSymbol(ticker: "AAPL", name: "Apple", description: "Test"), initialPrice: 100),
        .init(symbol: StockSymbol(ticker: "NVDA", name: "NVIDIA", description: "Test"), initialPrice: 300),
        .init(symbol: StockSymbol(ticker: "MSFT", name: "Microsoft", description: "Test"), initialPrice: 200),
    ])

    @Test("Sorts by price, highest first")
    func sortsByPrice() {
        let viewModel = SymbolListViewModel(store: PriceStore(priceFeed: FakePriceFeed(), catalog: catalog))

        #expect(viewModel.quotes.map(\.symbol.ticker) == ["NVDA", "MSFT", "AAPL"])
    }

    @Test("Sorts by price change, biggest gain first")
    func sortsByChange() async {
        let feed = FakePriceFeed()
        let viewModel = SymbolListViewModel(store: PriceStore(priceFeed: feed, catalog: catalog))

        feed.send(PriceUpdate(ticker: "AAPL", price: 110, timestamp: .now))   // +10%
        feed.send(PriceUpdate(ticker: "NVDA", price: 270, timestamp: .now))   // -10%
        await waitUntil { viewModel.quote(for: "NVDA")?.currentPrice == 270 }

        viewModel.sortOrder = .byChange

        #expect(viewModel.quotes.map(\.symbol.ticker) == ["AAPL", "MSFT", "NVDA"])
    }

    @Test("Toggle starts the feed, then stops it")
    func toggleFeed() async {
        let viewModel = SymbolListViewModel(store: PriceStore(priceFeed: FakePriceFeed(), catalog: catalog))
        #expect(viewModel.isFeedRunning == false)

        viewModel.toggleFeed()
        await waitUntil { viewModel.isFeedRunning }
        #expect(viewModel.isFeedRunning)

        viewModel.toggleFeed()
        await waitUntil { !viewModel.isFeedRunning }
        #expect(viewModel.isFeedRunning == false)
    }

    /// The store updates asynchronously, so give it a moment to catch up.
    private func waitUntil(_ condition: () -> Bool) async {
        for _ in 0..<100 where !condition() {
            try? await Task.sleep(for: .milliseconds(10))
        }
    }
}

// MARK: - Fake feed

/// A price feed the test controls directly.
private final class FakePriceFeed: PriceFeedService {
    let updates: AsyncStream<PriceUpdate>
    let connectionStates: AsyncStream<ConnectionState>

    private let updatesContinuation: AsyncStream<PriceUpdate>.Continuation
    private let stateContinuation: AsyncStream<ConnectionState>.Continuation

    init() {
        (updates, updatesContinuation) = AsyncStream.makeStream(of: PriceUpdate.self)
        (connectionStates, stateContinuation) = AsyncStream.makeStream(of: ConnectionState.self)
    }

    func send(_ update: PriceUpdate) {
        updatesContinuation.yield(update)
    }

    func start() async {
        stateContinuation.yield(.connected)
    }

    func stop() async {
        stateContinuation.yield(.disconnected)
    }
}
