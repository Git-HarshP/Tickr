//
//  WebSocketClient.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

public protocol WebSocketClient: Sendable {
    func connect() async throws
    func send(_ message: String) async throws
    func receive() async throws -> String
    func disconnect() async
}
