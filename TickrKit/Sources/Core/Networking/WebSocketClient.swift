//
//  WebSocketClient.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

/// A text-only WebSocket connection.
/// Kept as a protocol so tests can swap in a fake client.
public protocol WebSocketClient: Sendable {
    /// Connects and returns a stream of incoming text messages.
    /// The stream ends when the socket closes.
    func connect() async throws -> AsyncThrowingStream<String, Error>
    func send(_ message: String) async throws
    func disconnect() async
}
