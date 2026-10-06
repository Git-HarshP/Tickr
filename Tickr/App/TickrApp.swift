//
//  TickrApp.swift
//  Tickr
//
//  Created by HarshPipaliya on 05/10/2026.
//

import SwiftUI
import PriceFeed
import SymbolListFeature

@main
struct TickrApp: App {
    @State private var listViewModel: SymbolListViewModel
    // The app's dependencies are created here, in one place,
    // and passed down to the screens that need them.
    init() {
        let priceFeed = WebSocketPriceFeedService(url: URL(string: "wss://ws.postman-echo.com/raw")!)
        let store = PriceStore(priceFeed: priceFeed)
        _listViewModel = State(initialValue: SymbolListViewModel(store: store))
    }

    var body: some Scene {
        WindowGroup {
            SymbolListView(viewModel: listViewModel)
        }
    }
}
