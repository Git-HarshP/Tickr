//
//  RandomPriceGeneratorTests.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Testing
import Foundation
import PriceFeed

@Suite("RandomPriceGenerator")
struct RandomPriceGeneratorTests {

    private let minimumPrice = Decimal(1) / 100

    @Test("Price always stays within ±2% of the current price")
    func staysWithinBounds() {
        let generator = RandomPriceGenerator(maxChange: 0.02)

        for _ in 0..<1_000 {
            let next = generator.nextPrice(after: 100)
            #expect(next >= 98 && next <= 102)
        }
    }

    @Test("Price is rounded to at most 2 decimal places")
    func roundedToCents() {
        let generator = RandomPriceGenerator(maxChange: 0.02)

        for _ in 0..<1_000 {
            let next = generator.nextPrice(after: 187)
            let parts = "\(next)".split(separator: ".")
            let decimalPlaces = parts.count == 2 ? parts[1].count : 0
            #expect(decimalPlaces <= 2, "\(next) has more than 2 decimal places")
        }
    }

    @Test("Price never drops below 0.01, even over a long downward run")
    func neverBelowMinimum() {
        let generator = RandomPriceGenerator(maxChange: 0.02)
        var price = minimumPrice

        for _ in 0..<1_000 {
            price = generator.nextPrice(after: price)
            #expect(price >= minimumPrice)
        }
    }

    @Test("Zero max change returns the same price")
    func zeroChangeIsStable() {
        let generator = RandomPriceGenerator(maxChange: 0)
        let price = Decimal(string: "187.43")!

        #expect(generator.nextPrice(after: price) == price)
    }
}
