//
//  StockQuote.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation

public struct StockQuote: Sendable, Hashable, Identifiable {
    public let symbol: StockSymbol
    public let currentPrice: Decimal
    public let previousPrice: Decimal

    public var id: String { symbol.ticker }

    public var change: Decimal {
        currentPrice - previousPrice
    }

    public var changePercentage: Decimal {
        guard previousPrice != 0 else {
            return 0
        }
        return change / previousPrice
    }

    public var direction: PriceDirection {
        PriceDirection(previous: previousPrice, current: currentPrice)
    }

    public init(symbol: StockSymbol, currentPrice: Decimal, previousPrice: Decimal) {
        self.symbol = symbol
        self.currentPrice = currentPrice
        self.previousPrice = previousPrice
    }
}
