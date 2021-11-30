//
//  ListDeviceModel.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 30/11/2021.
//

import Foundation

struct ListDeviceModel: Codable {
    let value: [ListDevice]
}

struct ListDevice: Codable {
    let id: String
    let etag: String
    var displayName: String
    let template: String
    let enabled: Bool
}
