//
//  SymbolCatalog.swift
//  TickrKit
//
//  Created by HarshPipaliya on 05/10/2026.
//

import Foundation
import Domain

public struct SymbolCatalog: Sendable {

    public struct Entry: Sendable {
        public let symbol: StockSymbol
        public let initialPrice: Decimal

        public init(symbol: StockSymbol, initialPrice: Decimal) {
            self.symbol = symbol
            self.initialPrice = initialPrice
        }
    }

    public let entries: [Entry]

    public init(entries: [Entry]) {
        self.entries = entries
    }
}


extension SymbolCatalog {
    public static let standard = SymbolCatalog(entries: [
        Entry(
            symbol: StockSymbol(
                ticker: "AAPL",
                name: "Apple Inc.",
                description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide."
            ),
            initialPrice: 190
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "NVDA",
                name: "NVIDIA Corporation",
                description: "NVIDIA Corporation provides graphics and compute and networking solutions in the United States, Taiwan, China, and internationally."
            ),
            initialPrice: 880
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "MSFT",
                name: "Microsoft Corporation",
                description: "Microsoft Corporation develops, licenses, and supports software, services, devices, and solutions worldwide."
            ),
            initialPrice: 410
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "GOOG",
                name: "Alphabet Inc.",
                description: "Alphabet Inc. offers various products and platforms in the United States, Europe, the Middle East, Africa, the Asia-Pacific, Canada, and Latin America."
            ),
            initialPrice: 175
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "AMZN",
                name: "Amazon.com, Inc.",
                description: "Amazon.com, Inc. engages in the retail sale of consumer products and subscriptions through online and physical stores."
            ),
            initialPrice: 185
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "TSLA",
                name: "Tesla, Inc.",
                description: "Tesla, Inc. designs, develops, manufactures, leases, and sells electric vehicles, and energy generation and storage systems."
            ),
            initialPrice: 265
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "META",
                name: "Meta Platforms, Inc.",
                description: "Meta Platforms, Inc. engages in the development of products that enable people to connect and share with friends and family through mobile devices."
            ),
            initialPrice: 505
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "BRK.B",
                name: "Berkshire Hathaway Inc.",
                description: "Berkshire Hathaway Inc. provides property and casualty insurance and reinsurance, and utilities services."
            ),
            initialPrice: 450
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "JPM",
                name: "JPMorgan Chase & Co.",
                description: "JPMorgan Chase & Co. operates as a financial services company worldwide."
            ),
            initialPrice: 215
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "V",
                name: "Visa Inc.",
                description: "Visa Inc. operates as a payments technology company worldwide."
            ),
            initialPrice: 285
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "WMT",
                name: "Walmart Inc.",
                description: "Walmart Inc. engages in the operation of retail, wholesale, and other units worldwide."
            ),
            initialPrice: 68
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "MA",
                name: "Mastercard Incorporated",
                description: "Mastercard Incorporated operates as a technology company in the global payments industry."
            ),
            initialPrice: 480
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "DIS",
                name: "The Walt Disney Company",
                description: "The Walt Disney Company operates as an entertainment company worldwide."
            ),
            initialPrice: 95
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "NFLX",
                name: "Netflix, Inc.",
                description: "Netflix, Inc. provides entertainment services worldwide."
            ),
            initialPrice: 685
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "ADBE",
                name: "Adobe Inc.",
                description: "Adobe Inc. operates as a diversified software company worldwide."
            ),
            initialPrice: 575
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "CRM",
                name: "Salesforce, Inc.",
                description: "Salesforce, Inc. provides customer relationship management technology that brings companies and customers together worldwide."
            ),
            initialPrice: 305
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "ORCL",
                name: "Oracle Corporation",
                description: "Oracle Corporation offers products and services that address enterprise information technology environments worldwide."
            ),
            initialPrice: 165
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "INTC",
                name: "Intel Corporation",
                description: "Intel Corporation engages in the design, manufacture, and sale of computer products and technologies worldwide."
            ),
            initialPrice: 24
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "AMD",
                name: "Advanced Micro Devices, Inc.",
                description: "Advanced Micro Devices, Inc. operates as a semiconductor company worldwide."
            ),
            initialPrice: 165
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "PYPL",
                name: "PayPal Holdings, Inc.",
                description: "PayPal Holdings, Inc. operates a technology platform that enables digital payments worldwide."
            ),
            initialPrice: 78
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "CSCO",
                name: "Cisco Systems, Inc.",
                description: "Cisco Systems, Inc. designs, manufactures, and sells Internet Protocol based networking and other products worldwide."
            ),
            initialPrice: 58
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "IBM",
                name: "International Business Machines Corporation",
                description: "International Business Machines Corporation provides integrated solutions and services worldwide."
            ),
            initialPrice: 195
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "QCOM",
                name: "QUALCOMM Incorporated",
                description: "QUALCOMM Incorporated engages in the development and commercialization of foundational technologies for the wireless industry worldwide."
            ),
            initialPrice: 168
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "TXN",
                name: "Texas Instruments Incorporated",
                description: "Texas Instruments Incorporated designs, manufactures, and sells semiconductors to electronics designers and manufacturers worldwide."
            ),
            initialPrice: 198
        ),
        Entry(
            symbol: StockSymbol(
                ticker: "AVGO",
                name: "Broadcom Inc.",
                description: "Broadcom Inc. designs, develops, and supplies various semiconductor devices with a focus on complex digital and mixed signal solutions."
            ),
            initialPrice: 1650
        ),
    ])
}
