//
//  PriceDirection.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation

public enum PriceDirection: Sendable, Equatable {
    case up
    case down
    case unchanged

    public init(previous: Decimal, current: Decimal) {
        if current > previous {
            self = .up
        } else if current < previous {
            self = .down
        } else {
            self = .unchanged
        }
    }
}
