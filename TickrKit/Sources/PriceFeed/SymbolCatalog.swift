//
//  SymbolCatalog.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation
import Domain

public struct SymbolCatalog: Sendable {
    
    public struct Entry: Sendable {
        public let symbol: StockSymbol
        public let initialPrice: Decimal
        
        public init(symbol: StockSymbol, initialPrice: Decimal) {
            self.symbol = symbol
            self.initialPrice = initialPrice
        }
    }
    
    public let entries: [Entry]
    
    public init(entries: [Entry]) {
        self.entries = entries
    }
}


extension SymbolCatalog {
    public static let standard = SymbolCatalog(entries: [
        Entry(
            symbol: StockSymbol(
                ticker: "MBG",
                name: "MultiBank Group",
                description: "MultiBank Group"
            ),
            initialPrice: Decimal(string: "0.103")!
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "AAPL",
                name: "Apple Inc.",
                description: "Apple Incorporation Group"
            ),
            initialPrice: 190
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "NVDA",
                name: "NVIDIA Corporation",
                description: "NVIDIA Corporation group"
            ),
            initialPrice: 880
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "MSFT",
                name: "Microsoft Corporation",
                description: "Microsoft Corporation Group"
            ),
            initialPrice: 310
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "FB",
                name: "Meta Platforms, Inc.",
                description: "FB Group"
            ),
            initialPrice: 300
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "AMZN",
                name: "Amazon.com, Inc.",
                description: "AMZN Group"
            ),
            initialPrice: 340
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "BABA",
                name: "Alibaba Group Holding Limited",
                description: "BABA Group"
            ),
            initialPrice: 200
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "BIDU",
                name: "Baidu, Inc.",
                description: "BIDU Group"
            ),
            initialPrice: 100
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "ORCL",
                name: "ORCL, Inc.",
                description: "ORCL Group"
            ),
            initialPrice: 101
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "ADBE",
                name: "ADBE, Inc.",
                description: "ADBE Group"
            ),
            initialPrice: 102
        ),
        
    ])
}
