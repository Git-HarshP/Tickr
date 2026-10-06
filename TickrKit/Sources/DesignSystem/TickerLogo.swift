//
//  TickerLogo.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import SwiftUI

/// A round placeholder logo showing the ticker's first letter.
public struct TickerLogo: View {
    let ticker: String
    let size: CGFloat

    public init(ticker: String, size: CGFloat = 40) {
        self.ticker = ticker
        self.size = size
    }

    public var body: some View {
        Text(ticker.prefix(1))
            .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(Color.accentColor.gradient, in: .circle)
    }
}
