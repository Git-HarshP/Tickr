//
//  PriceGenerator.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation

public protocol PriceGenerator: Sendable {
    func nextPrice(after current: Decimal) -> Decimal
}
