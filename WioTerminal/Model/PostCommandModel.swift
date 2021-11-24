//
//  PostCommandModel.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 23/11/2021.
//

import Foundation

struct PostCommandModel: Codable {
    let request: Int
    let response: Response
    let responseCode: Int
}

struct Response: Codable {
}
