//
//  SymbolDetailView.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import SwiftUI
import Domain
import DesignSystem

public struct SymbolDetailView: View {
    let quote: StockQuote

    public init(quote: StockQuote) {
        self.quote = quote
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                priceCard

                HStack(spacing: 16) {
                    StatCard(title: "Previous", value: quote.previousPrice.formatted(.currency(code: "USD")))
                    StatCard(title: "Change", value: quote.change.formatted(.currency(code: "USD")))
                }

                aboutCard
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(quote.symbol.ticker)
        .navigationBarTitleDisplayMode(.inline)
        // Animates the numbers each time a new price arrives.
        .animation(.default, value: quote)
    }

    private var priceCard: some View {
        VStack(spacing: 12) {
            TickerLogo(ticker: quote.symbol.ticker, size: 64)

            Text(quote.symbol.name)
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text(quote.currentPrice, format: .currency(code: "USD"))
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())

            PriceChangeBadge(quote: quote)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .card()
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(.headline)

            Text(quote.symbol.description)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .card()
    }
}

/// A small card with a label above a value, e.g. "Previous / $187.43".
private struct StatCard: View {
    let title: LocalizedStringKey
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.semibold))
                .monospacedDigit()
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .card()
    }
}

private extension View {
    /// The rounded card background used by every section on this screen.
    func card() -> some View {
        background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        SymbolDetailView(quote: StockQuote(
            symbol: StockSymbol(ticker: "AAPL", name: "Apple Inc.", description: "Apple designs smartphones, computers and more."),
            currentPrice: 191.25,
            previousPrice: 189.80
        ))
    }
}
