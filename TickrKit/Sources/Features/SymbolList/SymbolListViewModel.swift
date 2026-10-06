//
//  SymbolListViewModel.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Domain
import Foundation
import Observation
import PriceFeed

enum SortOrder {
    case byPrice
    case byChange
}

/// Screen logic for the symbol list: sorting and starting/stopping the feed.
/// Kept out of the view so it can be unit tested without any UI.
@MainActor
@Observable
public final class SymbolListViewModel {
    var sortOrder: SortOrder = .byPrice

    private let store: PriceStore

    public init(store: PriceStore) {
        self.store = store
    }

    /// All quotes, highest first, by the selected sort order.
    var quotes: [StockQuote] {
        switch sortOrder {
        case .byPrice:
            store.allQuotes.sorted { $0.currentPrice > $1.currentPrice }
        case .byChange:
            store.allQuotes.sorted { $0.changePercentage > $1.changePercentage }
        }
    }

    var connectionState: ConnectionState {
        store.connectionState
    }

    var isFeedRunning: Bool {
        store.connectionState != .disconnected
    }

    func quote(for ticker: String) -> StockQuote? {
        store.quote(for: ticker)
    }

    func toggleFeed() {
        if isFeedRunning {
            store.stop()
        } else {
            store.start()
        }
    }
}
