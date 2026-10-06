# Tickr

A SwiftUI app that shows live prices for list of tokens.

Prices are generated every 2 seconds the app sends a random price for each symbol to an echo WebSocket server (`wss://ws.postman-echo.com/raw`). The server sends each message straight back, and those echoed prices are what the UI shows.

Here for echo WebSocket server and getting data back via socket used AI help to make TBH.

## ShowCase

https://github.com/user-attachments/assets/93d5d27d-6482-4b74-9bbc-ae378ac8f168

## Structure

Got an idea of creating `TickrKit`  package withing app with modules in it from flutter as in one of recent project added monorepos.

- Kept this package withing app as its small but as improvement this package can be moved to remote and can be distributed in small packages like `networking`, `DLS`, and `core`

as using modular clean design structure, `TickrKit` holds main code of app with small small modules in it:

| Module | What it does |
| --- | --- |
| `Domain` | Plain models: `StockSymbol`, `StockQuote`, `PriceUpdate`, `PriceDirection`, `ConnectionState`, and the `PriceFeedService` protocol. No UI, no networking. |
| `Networking` | `WebSocketClient` protocol and `URLSessionWebSocketClient`. |
| `PriceFeed` | `WebSocketPriceFeedService`, `RandomPriceGenerator`, the symbol list, JSON coding, and `PriceStore`, which the UI observes. |
| `DesignSystem` | Shared design tokens, like color and arrow for a price going up or down. |
| `SymbolListFeature` | The main list screen and its `SymbolListViewModel`. |
| `SymbolDetailFeature` | The detail screen for one symbol. |

## Possible improvements

- if connection dropped somehow app can try to reconnect automatically
- Since only showing 25 token yet didn't added way to only updated token prices which is visible on screen, and holding or controlling prise updates to 4 to 6 time a second instead keep on listening all price updated
