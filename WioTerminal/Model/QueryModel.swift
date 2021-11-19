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
    
    enum CodingKeys: String, CodingKey {
        case time = "$ts"
        case temp = "max_temp"
        case humi = "max_humi"
        case light = "max_light"
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct QueryModel: Codable {
    let results: [Item]
}
