//
//  PriceFeedService.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

/// A live source of price updates.
///
/// - Important: `updates` and `connectionStates` support a **single consumer**.
///   The app's shared price store is that consumer; UI reads from the store.
public protocol PriceFeedService: Sendable {
    func start() async
    func stop() async
    var updates: AsyncStream<PriceUpdate> { get }
    var connectionStates: AsyncStream<ConnectionState> { get }
}
