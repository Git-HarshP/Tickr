//
//  PriceUpdate.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation

public struct PriceUpdate: Sendable, Equatable {
    public let ticker: String
    public let price: Decimal
    public let timestamp: Date

    public init(ticker: String, price: Decimal, timestamp: Date) {
        self.ticker = ticker
        self.price = price
        self.timestamp = timestamp
    }
}
