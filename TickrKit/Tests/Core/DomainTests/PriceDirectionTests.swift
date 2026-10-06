//
//  PriceDirectionTests.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Testing
import Foundation
import Domain

@Suite("PriceDirection")
struct PriceDirectionTests {

    @Test("Direction relative to a previous price of 100", arguments: zip(
        [Decimal(105), 95, 100, Decimal(string: "100.0001")!],
        [PriceDirection.up, .down, .unchanged, .up]
    ))
    func direction(current: Decimal, expected: PriceDirection) {
        #expect(PriceDirection(previous: 100, current: current) == expected)
    }
}
