//
//  PriceFeedService.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

public protocol PriceFeedService: Sendable {
    func start() async
    func stop() async
    var updates: AsyncStream<PriceUpdate> { get }
    var connectionStates: AsyncStream<ConnectionState> { get }
}
