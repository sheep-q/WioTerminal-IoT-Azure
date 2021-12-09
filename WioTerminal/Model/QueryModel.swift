//
//  QueryModel.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//

import Foundation

struct Item: Codable, Hashable {
    var id = UUID()
    var time: String
    var temp: Double?
    var humi: Double?
    var light: Double?
    var x: Double?
    var y: Double?
    var z: Double?
    var location: Int?
    
    enum CodingKeys: String, CodingKey {
        case time = "$ts"
        case temp = "max_temp"
        case humi = "max_humi"
        case light = "max_light"
        case x = "max_accelX"
        case y = "max_accelY"
        case z = "max_accelZ"
        case location = "max_location"
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct QueryModel: Codable {
    let results: [Item]?
}
