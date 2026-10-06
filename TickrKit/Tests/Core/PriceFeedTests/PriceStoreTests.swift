//
//  PriceStoreTests.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Testing
import Foundation
import PriceFeed
import Domain

@Suite("PriceStore")
@MainActor
struct PriceStoreTests {
    
    @Test("Store initializes with catalog prices")
    func initializesWithCatalog() async {
        let catalog = SymbolCatalog(entries: [
            SymbolCatalog.Entry(
                symbol: StockSymbol(ticker: "AAPL", name: "Apple", description: "Tech"),
                initialPrice: 150
            )
        ])
        
        let mockFeed = MockPriceFeedService()
        let store = PriceStore(priceFeed: mockFeed, catalog: catalog)
        
        let quote = store.quote(for: "AAPL")
        #expect(quote?.currentPrice == 150)
        #expect(quote?.previousPrice == 150)
    }
    
    @Test("Store updates quotes when price updates arrive")
    func updatesQuotes() async throws {
        let catalog = SymbolCatalog(entries: [
            SymbolCatalog.Entry(
                symbol: StockSymbol(ticker: "AAPL", name: "Apple", description: "Tech"),
                initialPrice: 150
            )
        ])
        
        let mockFeed = MockPriceFeedService()
        let store = PriceStore(priceFeed: mockFeed, catalog: catalog)
        
        // Send a price update
        await mockFeed.sendUpdate(PriceUpdate(ticker: "AAPL", price: 155, timestamp: Date()))
        
        // Give the async stream time to process
        try await Task.sleep(for: .milliseconds(100))
        
        let quote = store.quote(for: "AAPL")
        #expect(quote?.currentPrice == 155)
        #expect(quote?.previousPrice == 150)
    }
    
    @Test("Store tracks connection state")
    func tracksConnectionState() async throws {
        let catalog = SymbolCatalog.standard
        let mockFeed = MockPriceFeedService()
        let store = PriceStore(priceFeed: mockFeed, catalog: catalog)
        
        #expect(store.connectionState == .disconnected)
        
        await mockFeed.sendState(.connecting)
        try await Task.sleep(for: .milliseconds(100))
        #expect(store.connectionState == .connecting)
        
        await mockFeed.sendState(.connected)
        try await Task.sleep(for: .milliseconds(100))
        #expect(store.connectionState == .connected)
    }
}

// MARK: - Mock Implementation

private actor MockPriceFeedService: PriceFeedService {
    private var updatesContinuation: AsyncStream<PriceUpdate>.Continuation?
    private var stateContinuation: AsyncStream<ConnectionState>.Continuation?
    
    nonisolated let updates: AsyncStream<PriceUpdate>
    nonisolated let connectionStates: AsyncStream<ConnectionState>
    
    init() {
        let (updates, updatesContinuation) = AsyncStream.makeStream(of: PriceUpdate.self)
        let (states, stateContinuation) = AsyncStream.makeStream(of: ConnectionState.self)
        
        self.updates = updates
        self.connectionStates = states
        self.updatesContinuation = updatesContinuation
        self.stateContinuation = stateContinuation
        
        // Start with disconnected state
        stateContinuation.yield(.disconnected)
    }
    
    func start() async {
        stateContinuation?.yield(.connecting)
        stateContinuation?.yield(.connected)
    }
    
    func stop() async {
        stateContinuation?.yield(.disconnected)
    }
    
    func sendUpdate(_ update: PriceUpdate) {
        updatesContinuation?.yield(update)
    }
    
    func sendState(_ state: ConnectionState) {
        stateContinuation?.yield(state)
    }
}
