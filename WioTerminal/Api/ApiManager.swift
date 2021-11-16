//
//  ApiManager.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import Foundation

class ApiManager: ObservableObject {
    private static let shared = ApiManager()
    
    private var deviceTemplateAPI = DeviceTemplateAPI()
    static var deviceTemplate: DeviceTemplateAPI { shared.deviceTemplateAPI }
}
