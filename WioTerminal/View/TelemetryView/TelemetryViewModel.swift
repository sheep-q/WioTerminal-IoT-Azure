//
//  TelemetryViewModel.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 17/11/2021.
//

import Foundation
import SwiftUI

enum CommandRequest {
    case notRequest
    case requesting
    case done
}

class TelemetryViewModel: ObservableObject {
    @Published var temp: Int = 0
    @Published var humi: Int = 0
    @Published var light: Int = 0
    @Published var soil: Int = 0
    
    @Published var queryItems = [Item]()
    @Published var tempItems: [Double] = []
    @Published var tempDatas: [(String, Double)] = []
    @Published var humiDatas: [(String, Double)] = []
    @Published var offsetY: CGFloat = 0
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled {
                offsetY = 200
            } else {
                offsetY = 0
            }
        }
    }
    
    @Published var number = 8
    @Published var time = 1
    @Published var day = 0
   
    static let numbers = [1, 2, 5, 10, 15, 20, 30, 45, 60]
    static let times = ["giây(s)", "phút(m)", "giờ"]
    static let days = [1,2,3,4,5,6,7]
    
    @Published var requestBuzzerCommandAlert: CommandRequest = .notRequest
    @Published var isShowingBuzzerCommandAlert = false
    
    // MARK: -  post Command Buzzer
    func postBuzzerCommand(body: String) {
        let number: Int = Int(body) ?? 0
        ApiManager.shared.postBuzzerCommand(body: String(number * 1000)) {
            switch $0 {
            case .success(_):
                DispatchQueue.main.async {
                    self.requestBuzzerCommandAlert = .done
                    self.isShowingBuzzerCommandAlert = true
                }
            case .failure(let err):
                self.requestBuzzerCommandAlert = .notRequest
                printDebug(err.localizedDescription)
            }
        }
    }
    
    // MARK: -  get Telemetry
    func getTelemetry() {
        ApiManager.shared.getTelemetry(telemetry: "temp") {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.temp = telemetry?.value ?? 0
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
                    self.humi = telemetry?.value ?? 0
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
                    self.light = telemetry?.value ?? 0
                }
            case let .failure(err):
                print("failed")
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: -  post Query
    func postQuery(body: String = APIConstant.getBody(number: 60, time: TelemetryViewModel.times[1], day: 1)) {
        ApiManager.shared.postQuery(body: body) {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.queryItems = telemetry?.results ?? []
                    self.tempItems = self.queryItems.map({ $0.temp ?? 0 })
                    self.tempDatas = []
                    self.humiDatas = []
                    for item in self.queryItems {
                        let time: String = convertToDate(string: item.time)
                        self.tempDatas.append((time, item.temp ?? 0))
                        self.humiDatas.append((time, item.humi ?? 0))
                    }  
                }
            case let .failure(err):
                print("failed")
                printDebug("body: \(body)")
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
    dateFormatter1.dateFormat = "HH:mm:ss\nMM-dd"
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
    dateFormatter1.dateFormat = "HH:mm:ss"
    dateFormatter1.timeZone = TimeZone.current
    let stringConverted = dateFormatter1.string(from: date ?? Date())
    return stringConverted
}
