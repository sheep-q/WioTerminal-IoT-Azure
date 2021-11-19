//
//  TelemetryViewModel.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 17/11/2021.
//

import Foundation
import SwiftUI

class TelemetryViewModel: ObservableObject {
    @Published var temp: Int = 0
    @Published var humi: Int = 0
    @Published var light: Int = 0
    @Published var soil: Int = 0
    @Published var queryItems = [Item]()
    @Published var tempItems: [Double] = []
    @Published var tempDatas: [(String, Double)] = []
    @Published var humiDatas: [(String, Double)] = []
    
    func getTelemetry() {
        ApiManager.shared.getTelemetry(telemetry: "temp") {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.temp = telemetry.value
                }
            case let .failure(err):
                print("failed")
                print(err.localizedDescription)
            }
        }
        
        ApiManager.shared.getTelemetry(telemetry: "humi") {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.humi = telemetry.value
                }
            case let .failure(err):
                print("failed")
                print(err.localizedDescription)
            }
        }
        
        ApiManager.shared.getTelemetry(telemetry: "light") {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.light = telemetry.value
                }
            case let .failure(err):
                print("failed")
                print(err.localizedDescription)
            }
        }
    }
    
    func postQuery(body: String = "SELECT MAX(temp), AVG(temp), MAX(humi), MAX(light) FROM dtmi:modelDefinition:jyf9vhwxe:jar8rfo1yh WHERE WITHIN_WINDOW(P1D) AND temp > 0 GROUP BY WINDOW(PT5M) ORDER BY $ts ASC") {
        ApiManager.shared.postQuery(body: body) {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.queryItems = telemetry.results
                    self.tempItems = self.queryItems.map({ $0.temp ?? 0 })
                    printDebug(self.tempItems)
                    self.tempDatas = []
                    for item in self.queryItems {
                        let time: String = convertToDate(string: item.time)
                        self.tempDatas.append((time, item.temp ?? 0))
                        self.humiDatas.append((time, item.humi ?? 0))
                    }
                    
                    
                }
            case let .failure(err):
                print("failed")
                print(err.localizedDescription)
            }
        }
    }
}

public func convertToDate(string: String) -> String {
    let timeString = string
    let dateFomatter = DateFormatter()
    dateFomatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFomatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = dateFomatter.date(from: timeString)
    
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "HH:mm\nMM-dd"
    dateFormatter1.timeZone = TimeZone.current
    let stringConverted = dateFormatter1.string(from: date ?? Date())
    return stringConverted
}

public func convertToHour(string: String) -> String {
    let timeString = string
    let dateFomatter = DateFormatter()
    dateFomatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFomatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = dateFomatter.date(from: timeString)
    
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "HH:mm"
    dateFormatter1.timeZone = TimeZone.current
    let stringConverted = dateFormatter1.string(from: date ?? Date())
    return stringConverted
}
