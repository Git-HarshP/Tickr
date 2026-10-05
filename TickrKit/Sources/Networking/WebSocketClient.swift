//
//  WebSocketClient.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

public protocol WebSocketClient: Sendable {
    /// Connects and returns a stream of incoming text messages.
    /// The stream finishes on disconnect, or throws if the connection fails.
    func connect() async throws -> AsyncThrowingStream<String, Error>
    func send(_ message: String) async throws
    func disconnect() async
}
