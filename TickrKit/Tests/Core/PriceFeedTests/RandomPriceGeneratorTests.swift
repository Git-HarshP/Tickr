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

    private let minimumPrice = Decimal(string: "0.01")!

    @Test("Never moves more than maxChange")
    func staysWithinBounds() {
        let generator = RandomPriceGenerator(maxChange: 0.02)

        for _ in 0..<1_000 {
            let next = generator.nextPrice(after: 100)
            #expect(next >= 98 && next <= 102)
        }
    }

    @Test("Prices are rounded to cents")
    func roundedToCents() {
        let generator = RandomPriceGenerator(maxChange: 0.02)

        for _ in 0..<1_000 {
            let next = generator.nextPrice(after: 187)
            let decimals = "\(next)".split(separator: ".").dropFirst().first?.count ?? 0
            #expect(decimals <= 2, "\(next) has more than 2 decimal places")
        }
    }

    @Test("Never drops below one cent")
    func neverBelowMinimum() {
        let generator = RandomPriceGenerator(maxChange: 0.02)
        var price = minimumPrice

        for _ in 0..<1_000 {
            price = generator.nextPrice(after: price)
            #expect(price >= minimumPrice)
        }
    }

    @Test("Zero maxChange keeps the price the same")
    func zeroChangeIsStable() {
        let generator = RandomPriceGenerator(maxChange: 0)
        let price = Decimal(string: "187.43")!

        #expect(generator.nextPrice(after: price) == price)
    }
}
