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
    static let deviceId = "wio_terminal"
    static let deviceTemplateId = "dtmi:modelDefinition:f86ewnoegn:hhdpxfy4dw"
    static let authorizationString = "SharedAccessSignature sr=abd94bd3-8a1e-43ca-b038-b083a16ebef2&sig=GadOhEWrny8kYORfGvVex14Xbbbx3%2FD6DnummWYgUQw%3D&skn=token11-10&se=1668061647942"
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
