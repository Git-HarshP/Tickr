//
//  PriceUpdateDTO.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation
import Domain

struct PriceUpdateDTO: Codable, Equatable {
    let ticker: String
    let price: String
    let timestamp: Date
}

extension PriceUpdateDTO {
    init(_ update: PriceUpdate) {
        ticker = update.ticker
        price = "\(update.price)"
        timestamp = update.timestamp
    }

    func toDomain() throws -> PriceUpdate {
        guard let value = Decimal(string: price, locale: Locale(identifier: "en_US_POSIX")) else {
            throw PriceFeedError.invalidMessage
        }
        return PriceUpdate(ticker: ticker, price: value, timestamp: timestamp)
    }
}
