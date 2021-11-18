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
    static let deviceTemplateId = "dtmi:modelDefinition:f86ewnoegn:hhdpxfy4dw"
    static let authorizationString = "SharedAccessSignature sr=f2a5c990-8900-4a68-b779-76c40f515b2d&sig=iCs3HyUggu8HXuvDa0MYY5P9CxVOYJzZ7SNVtaJdQZc%3D&skn=token&se=1668700833396"
}

struct Path {
    static let getDeviceTemplate = "/deviceTemplates"
    static let getTelemetry = "/devices/\(APIConstant.deviceId)/telemetry"
}

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}
