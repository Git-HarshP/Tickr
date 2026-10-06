//
//  PriceChangeBadge.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import SwiftUI
import Domain

/// A coloured pill with an arrow and the percentage change, e.g. "▲ 1.25%".
public struct PriceChangeBadge: View {
    let quote: StockQuote

    public init(quote: StockQuote) {
        self.quote = quote
    }

    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: quote.direction.arrowSymbol)
            // The arrow already shows the sign, so show the size of the change only.
            Text(abs(quote.changePercentage), format: .percent.precision(.fractionLength(2)))
                .contentTransition(.numericText())
        }
        .font(.caption.weight(.semibold))
        .monospacedDigit()
        .foregroundStyle(quote.direction.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(quote.direction.color.opacity(0.15), in: .capsule)
    }
}
