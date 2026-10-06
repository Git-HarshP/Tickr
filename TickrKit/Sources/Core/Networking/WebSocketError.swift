//
//  WebSocketError.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

public enum WebSocketError: Error, Sendable {
    case notConnected
    case connectionFailed
}
