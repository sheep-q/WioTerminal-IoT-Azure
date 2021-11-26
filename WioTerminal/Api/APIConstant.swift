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
    static let deviceTemplateId = "dtmi:modelDefinition:t5cp9xuag:lhstobvlb8"
    static let authorizationString = "SharedAccessSignature sr=c5c95af8-b0b7-44d3-b0e8-800f72170fc5&sig=3TsHAwNRAHSDeitDA%2BdtlLD8jw9aSgwBNeoAtm%2FsI3A%3D&skn=token&se=1669434747676"
    
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
    static let postBuzzerCommand = "/devices/\(APIConstant.deviceId)/commands/ringBuzzer"
}

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}
