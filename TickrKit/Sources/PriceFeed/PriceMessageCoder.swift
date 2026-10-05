//
//  PriceMessageCoder.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation
import Domain


enum PriceMessageCoder {
    static func encode(_ update: PriceUpdate) throws -> String {
        let dto = PriceUpdateDTO(update)
        let data = try makeEncoder().encode(dto)
        return String(decoding: data, as: UTF8.self)
    }

    static func decode(_ text: String) throws -> PriceUpdate {
        let data = Data(text.utf8)
        let dto = try makeDecoder().decode(PriceUpdateDTO.self, from: data)
        return try dto.toDomain()
    }

    private static func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return encoder
    }

    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }
}
