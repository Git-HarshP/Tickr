//
//  URLSessionWebSocketClient.swift
//  TickrKit
//
//  Created by HarshPipaliya on 06/10/2026.
//

import Foundation

/// WebSocket client built on Apple's `URLSessionWebSocketTask`.
public actor URLSessionWebSocketClient: WebSocketClient {
    private let url: URL
    private var task: URLSessionWebSocketTask?

    public init(url: URL) {
        self.url = url
    }

    public func connect() async throws -> AsyncThrowingStream<String, Error> {
        let task = URLSession.shared.webSocketTask(with: url)
        task.resume()
        self.task = task

        // A ping only succeeds once the connection is open,
        // so this tells us whether connecting worked.
        do {
            try await ping(task)
        } catch {
            disconnect()
            throw WebSocketError.connectionFailed
        }

        // Each time the caller asks for the next message, wait for one.
        // `receive()` throws when the socket closes, which ends the stream.
        return AsyncThrowingStream {
            switch try await task.receive() {
            case .string(let text):
                return text
            case .data(let data):
                return String(decoding: data, as: UTF8.self)
            @unknown default:
                return nil
            }
        }
    }

    public func send(_ message: String) async throws {
        guard let task else {
            throw WebSocketError.notConnected
        }
        try await task.send(.string(message))
    }

    public func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
    }

    private func ping(_ task: URLSessionWebSocketTask) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            task.sendPing { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
