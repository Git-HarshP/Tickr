//
//  PriceStore.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Foundation
import Observation
import Domain

/// Holds the latest quote for every symbol. The UI reads from here.
///
/// This is the single consumer of the price feed's streams.
@MainActor
@Observable
public final class PriceStore {
    public private(set) var quotes: [String: StockQuote] = [:]
    public private(set) var connectionState: ConnectionState = .disconnected

    private let priceFeed: PriceFeedService

    public init(priceFeed: PriceFeedService, catalog: SymbolCatalog = .standard) {
        self.priceFeed = priceFeed

        // Start every symbol at its initial price, with no change yet.
        for entry in catalog.entries {
            quotes[entry.symbol.ticker] = StockQuote(
                symbol: entry.symbol,
                currentPrice: entry.initialPrice,
                previousPrice: entry.initialPrice
            )
        }

        listenToFeed()
    }

    public var allQuotes: [StockQuote] {
        Array(quotes.values)
    }

    public func quote(for ticker: String) -> StockQuote? {
        quotes[ticker]
    }

    public func start() {
        Task { await priceFeed.start() }
    }

    public func stop() {
        Task { await priceFeed.stop() }
    }

    private func listenToFeed() {
        Task {
            for await update in priceFeed.updates {
                apply(update)
            }
        }
        Task {
            for await state in priceFeed.connectionStates {
                connectionState = state
            }
        }
    }

    private func apply(_ update: PriceUpdate) {
        guard let quote = quotes[update.ticker] else { return }

        quotes[update.ticker] = StockQuote(
            symbol: quote.symbol,
            currentPrice: update.price,
            previousPrice: quote.currentPrice
        )
    }
}
