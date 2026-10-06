//
//  PriceDirection+Style.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Domain
import SwiftUI

/// How a price movement looks on screen. Shared by the list and detail screens.
extension PriceDirection {
    public var color: Color {
        switch self {
        case .up: .green
        case .down: .red
        case .unchanged: .gray
        }
    }

    public var arrowSymbol: String {
        switch self {
        case .up: "arrow.up"
        case .down: "arrow.down"
        case .unchanged: "minus"
        }
    }
}
