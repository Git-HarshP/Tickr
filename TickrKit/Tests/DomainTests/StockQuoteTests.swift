//
//  StockQuoteTests.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Testing
import Foundation
import Domain

@Suite("StockQuote")
struct StockQuoteTests {

    @Test("Change is current minus previous", arguments: zip(
        [Decimal(150), 80],
        [Decimal(50), -20]
    ))
    func change(current: Decimal, expected: Decimal) {
        #expect(makeQuote(previous: 100, current: current).change == expected)
    }

    @Test("Change percentage is a fraction (0.05 = 5%)")
    func changePercentageIsFraction() {
        let quote = makeQuote(previous: 100, current: 105)
        #expect(quote.changePercentage == Decimal(string: "0.05")!)
    }

    @Test("Zero previous price returns 0 instead of crashing")
    func changePercentageWithZeroPrevious() {
        #expect(makeQuote(previous: 0, current: 100).changePercentage == 0)
    }

    @Test("Direction follows price movement", arguments: zip(
        [Decimal(150), 80, 100],
        [PriceDirection.up, .down, .unchanged]
    ))
    func direction(current: Decimal, expected: PriceDirection) {
        #expect(makeQuote(previous: 100, current: current).direction == expected)
    }

    @Test("ID equals the symbol's ticker")
    func idEqualsTicker() {
        #expect(makeQuote(previous: 100, current: 150).id == "AAPL")
    }
}

private func makeQuote(previous: Decimal, current: Decimal) -> StockQuote {
    StockQuote(
        symbol: StockSymbol(ticker: "AAPL", name: "Apple Inc.", description: "Test"),
        currentPrice: current,
        previousPrice: previous
    )
}
