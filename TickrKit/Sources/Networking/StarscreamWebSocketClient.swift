//
//  StarscreamWebSocketClient.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation
@preconcurrency import Starscream

public actor StarscreamWebSocketClient: WebSocketClient {
    private let url: URL
    private var socket: WebSocket?
    private var messageContinuation: AsyncThrowingStream<String, Error>.Continuation?
    
    public init(url: URL) {
        self.url = url
    }
    
    public func connect() async throws -> AsyncThrowingStream<String, Error> {
        // 1. Two streams: one for lifecycle events, one for messages
        let (events, eventContinuation) = AsyncStream.makeStream(
            of: LifecycleEvent.self,
            bufferingPolicy: .bufferingNewest(1)
        )
        let (messages, messageContinuation) = AsyncThrowingStream.makeStream(of: String.self)
        
        // 2. Configure the socket
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        let socket = WebSocket(request: request)
        socket.callbackQueue = DispatchQueue(label: "com.tickr.websocket")
        
        // 3. Route Starscream's callbacks into the two streams
        socket.onEvent = { event in
            switch event {
            case .connected:
                eventContinuation.yield(.connected)
            case .text(let text):
                messageContinuation.yield(text)
            case .disconnected, .cancelled, .peerClosed:
                eventContinuation.yield(.closed)
                messageContinuation.finish()
            case .error:
                eventContinuation.yield(.closed)
                messageContinuation.finish(throwing: WebSocketError.connectionFailed)
            default:
                break
            }
        }
        
        self.socket = socket
        self.messageContinuation = messageContinuation
        socket.connect()
        
        // 4. Wait until we know whether the connection succeeded
        for await event in events {
            switch event {
            case .connected:
                return messages
            case .closed:
                self.socket = nil
                throw WebSocketError.connectionFailed
            }
        }
        throw WebSocketError.connectionFailed
    }
    
    public func send(_ message: String) async throws {
        guard let socket else {
            throw WebSocketError.notConnected
        }
        
        await withCheckedContinuation { continuation in
            socket.write(string: message) {
                continuation.resume()
            }
        }
    }
    
    public func disconnect() {
        socket?.disconnect()
        socket = nil
        messageContinuation?.finish()
        messageContinuation = nil
    }
}

private enum LifecycleEvent: Sendable {
    case connected
    case closed
}
