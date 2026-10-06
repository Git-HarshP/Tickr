//
//  PriceMessageCoder.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation
import Domain

/// Turns a `PriceUpdate` into the JSON text sent over the WebSocket, and back.
///
/// Example: `{"ticker":"AAPL","price":"187.43","timestamp":1700000000000}`
enum PriceMessageCoder {
    /// The JSON shape. The price is a string so the exact `Decimal`
    /// value survives the round trip (JSON numbers are read as `Double`).
    private struct Message: Codable {
        let ticker: String
        let price: String
        let timestamp: Date
    }

    static func encode(_ update: PriceUpdate) throws -> String {
        let message = Message(ticker: update.ticker, price: "\(update.price)", timestamp: update.timestamp)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return String(decoding: try encoder.encode(message), as: UTF8.self)
    }

    static func decode(_ text: String) throws -> PriceUpdate {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let message = try decoder.decode(Message.self, from: Data(text.utf8))

        guard let price = Decimal(string: message.price, locale: Locale(identifier: "en_US_POSIX")) else {
            throw PriceFeedError.invalidMessage
        }
        return PriceUpdate(ticker: message.ticker, price: price, timestamp: message.timestamp)
    }
}
