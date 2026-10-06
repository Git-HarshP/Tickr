//
//  StockSymbol.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

public struct StockSymbol: Sendable, Hashable, Identifiable {
    public let ticker: String
    public let name: String
    public let description: String

    public var id: String { ticker }

    public init(ticker: String, name: String, description: String) {
        self.ticker = ticker
        self.name = name
        self.description = description
    }
}
