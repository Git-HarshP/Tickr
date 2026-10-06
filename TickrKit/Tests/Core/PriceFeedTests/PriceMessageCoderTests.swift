//
//  PriceMessageCoderTests.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Testing
import Foundation
import Domain
@testable import PriceFeed

@Suite("PriceMessageCoder")
struct PriceMessageCoderTests {

    @Test("Encoding then decoding gives back the same update")
    func roundTrip() throws {
        let update = PriceUpdate(
            ticker: "AAPL",
            price: Decimal(string: "187.43")!,
            timestamp: Date(timeIntervalSince1970: 1_700_000_000)
        )

        let text = try PriceMessageCoder.encode(update)

        #expect(try PriceMessageCoder.decode(text) == update)
    }

    @Test("Invalid messages throw")
    func invalidMessage() {
        #expect(throws: (any Error).self) {
            try PriceMessageCoder.decode("not json")
        }
        #expect(throws: PriceFeedError.invalidMessage) {
            try PriceMessageCoder.decode(#"{"ticker":"AAPL","price":"abc","timestamp":0}"#)
        }
    }
}
