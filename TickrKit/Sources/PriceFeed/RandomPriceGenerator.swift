//
//  RandomPriceGenerator.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Foundation

public struct RandomPriceGenerator: PriceGenerator {
    private let maxChange: Double
    private let minimumPrice = Decimal(1) / 100   // exactly 0.01

    /// - Parameter maxChange: Largest move per tick as a fraction (0.02 = ±2%).
    public init(maxChange: Double = 0.02) {
        self.maxChange = maxChange
    }

    public func nextPrice(after current: Decimal) -> Decimal {
        let change = Double.random(in: -maxChange...maxChange)
        let next = current * (1 + Decimal(change))
        let rounded = roundedToCents(next)
        return max(rounded, minimumPrice)
    }

    private func roundedToCents(_ value: Decimal) -> Decimal {
        var input = value
        var result = Decimal()
        NSDecimalRound(&result, &input, 2, .plain)
        return result
    }
}
