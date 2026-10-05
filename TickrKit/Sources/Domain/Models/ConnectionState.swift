//
//  ConnectionState.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation

public enum ConnectionState: Sendable, Equatable {
    case connecting
    case connected
    case disconnected
}
