//
//  Telemetry.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 16/11/2021.
//

import Foundation

struct Telemetry: Codable {
    let timestamp: String
    let value: Int
}

enum BanerTitle: String {
    case green = "rất tốt 🥰"
    case yellow = "cảnh báo 🙄"
    case red = "nguy hiểm 🤬"
}
