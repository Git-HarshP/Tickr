//
//  SymbolListView.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import SwiftUI
import Domain
import DesignSystem
import SymbolDetailFeature

public struct SymbolListView: View {
    // The app owns the ViewModel. `@Bindable` lets the sort picker bind to it.
    @Bindable private var viewModel: SymbolListViewModel
    
    public init(viewModel: SymbolListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section {
                    ConnectionStatusHeaderView(state: viewModel.connectionState)
                }
                
                Section("Stocks") {
                    ForEach(viewModel.quotes) { quote in
                        // Navigate by ticker, so the detail screen looks up
                        // the latest quote and keeps updating.
                        NavigationLink(value: quote.symbol.ticker) {
                            SymbolRow(quote: quote)
                        }
                    }
                }
            }
            // Animates rows moving when the sort order or prices change.
            .animation(.default, value: viewModel.quotes)
            .navigationTitle("Tickr")
            .navigationDestination(for: String.self) { ticker in
                if let quote = viewModel.quote(for: ticker) {
                    SymbolDetailView(quote: quote)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortMenu
                }
            }
            // Pins the button above the home indicator, on top of the list.
            .safeAreaInset(edge: .bottom) {
                feedButton
                    .padding()
                    .background(.bar)
            }
        }
    }
    
    private var sortMenu: some View {
        Menu {
            Picker("Sort By", selection: $viewModel.sortOrder) {
                Label("Price", systemImage: "dollarsign").tag(SortOrder.byPrice)
                Label("Price Change", systemImage: "percent").tag(SortOrder.byChange)
            }
        } label: {
            Label("Sort", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
    
    private var feedButton: some View {
        Button {
            viewModel.toggleFeed()
        } label: {
            Label(
                viewModel.isFeedRunning ? "Stop Feed" : "Start Feed",
                systemImage: viewModel.isFeedRunning ? "stop.fill" : "play.fill"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(viewModel.isFeedRunning ? .red : .green)
    }
}

private struct SymbolRow: View {
    let quote: StockQuote
    
    var body: some View {
        HStack(spacing: 12) {
            TickerLogo(ticker: quote.symbol.ticker)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(quote.symbol.ticker)
                    .font(.headline)
                Text(quote.symbol.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(quote.currentPrice, format: .currency(code: "USD"))
                    .font(.headline)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                
                PriceChangeBadge(quote: quote)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ConnectionStatusHeaderView: View {
    let state: ConnectionState
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .shadow(color: color.opacity(0.5), radius: 4)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(color)
                .symbolEffect(.pulse, isActive: state == .connecting)
        }
        .padding(.vertical, 8)
        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .listRowBackground(color.opacity(0.1))
    }
    
    private var color: Color {
        switch state {
        case .connected: .green
        case .connecting: .yellow
        case .disconnected: .red
        }
    }
    
    private var title: String {
        switch state {
        case .connected: "Connected"
        case .connecting: "Connecting"
        case .disconnected: "Disconnected"
        }
    }
    
    private var subtitle: String {
        switch state {
        case .connected: "Real-time data streaming"
        case .connecting: "Establishing connection..."
        case .disconnected: "No live data"
        }
    }
    
    private var iconName: String {
        switch state {
        case .connected: "checkmark.circle.fill"
        case .connecting: "arrow.clockwise"
        case .disconnected: "exclamationmark.triangle.fill"
        }
    }
}

#if DEBUG
import PriceFeed

#Preview {
    SymbolListView(viewModel: SymbolListViewModel(store: PriceStore(priceFeed: PreviewPriceFeed())))
}

/// An offline price feed for previews: shows the catalog's starting prices
/// and lets Start/Stop change the connection state, without any network.
private final class PreviewPriceFeed: PriceFeedService {
    let updates: AsyncStream<PriceUpdate>
    let connectionStates: AsyncStream<ConnectionState>
    
    private let stateContinuation: AsyncStream<ConnectionState>.Continuation
    
    init() {
        updates = AsyncStream { _ in }
        (connectionStates, stateContinuation) = AsyncStream.makeStream(of: ConnectionState.self)
    }
    
    func start() async {
        stateContinuation.yield(.connected)
    }
    
    func stop() async {
        stateContinuation.yield(.disconnected)
    }
}
#endif
