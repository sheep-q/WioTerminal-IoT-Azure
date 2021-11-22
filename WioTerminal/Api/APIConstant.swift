//
//  APIConstant.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import Foundation

struct APIConstant {
    
    //MARK: - Base domain
    static let subDomain = "wioterminal"
    static let baseDomain = "https://\(subDomain).azureiotcentral.com/api"
    static let deviceId = "wioTerminal"
    static let deviceTemplateId = "dtmi:modelDefinition:jyf9vhwxe:jar8rfo1yh"
    static let authorizationString = "SharedAccessSignature sr=f2a5c990-8900-4a68-b779-76c40f515b2d&sig=iCs3HyUggu8HXuvDa0MYY5P9CxVOYJzZ7SNVtaJdQZc%3D&skn=token&se=1668700833396"
    
    static func getBody(number: Int, time: String, day: Int) -> String {
        var timeString = ""
        
        if time == TelemetryViewModel.times[0] {
            timeString = "S"
        } else if time == TelemetryViewModel.times[1] {
            timeString = "M"
        } else {
            timeString = "H"
        }
        
        return "SELECT MAX(temp), AVG(temp), MAX(humi), MAX(light) FROM \(deviceTemplateId) WHERE WITHIN_WINDOW(P\(day)D) AND temp > 0 GROUP BY WINDOW(PT\(number)\(timeString)) ORDER BY $ts ASC"
    }
}

struct Path {
    static let getDeviceTemplate = "/deviceTemplates"
    static let getTelemetry = "/devices/\(APIConstant.deviceId)/telemetry"
    static let postQuery = "/query"
}

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}
