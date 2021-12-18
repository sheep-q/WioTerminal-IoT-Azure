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
    @Published var temp: Int = 7
    @Published var humi: Int = 17
    @Published var light: Int = 27
    @Published var soil: Int = 0
    
    @Published var transportDatas = [PositionModel]()
    @Published var mockItems: [Item] = PositionModel.mockItems()
    @Published var currentLocation: Int = 0
    
    var isFirstTime = true
    private var timeLoop = 0
    
    @Published var queryItems = [Item]()
    @Published var tempItems: [Double] = []
    @Published var tempDatas: [(String, Double)]
    @Published var humiDatas: [(String, Double)]
    @Published var lightDatas: [(String, Double)]
    @Published var locationDatas = [Item]()
    @Published var xDatas: [Double]
    @Published var yDatas: [Double]
    @Published var zDatas: [Double]
    
    @Published var offsetY: CGFloat = 0
    @Published var banerColor: Color = Color(hex: Constant.banerGreen)
    @Published var banerTitle: BanerTitle = .green
    @Published var tempColor: Color = Color(hex: Constant.banerGreen) {
        didSet {
            if tempColor == Color(hex: Constant.banerRed) || humiColor == Color(hex: Constant.banerRed) {
                banerColor = Color(hex: Constant.banerRed)
                banerTitle = .red
            } else if tempColor == Color(hex: Constant.banerYellow) || humiColor == Color(hex: Constant.banerYellow) {
                banerColor = Color(hex: Constant.banerYellow)
                banerTitle = .yellow
            } else {
                banerColor = Color(hex: Constant.banerGreen)
                banerTitle = .green
            }
        }
    }
    @Published var humiColor: Color = Color(hex: Constant.banerGreen) {
        didSet {
            if tempColor == Color(hex: Constant.banerRed) || humiColor == Color(hex: Constant.banerRed) {
                banerColor = Color(hex: Constant.banerRed)
                banerTitle = .red
            } else if tempColor == Color(hex: Constant.banerYellow) || humiColor == Color(hex: Constant.banerYellow) {
                banerColor = Color(hex: Constant.banerYellow)
                banerTitle = .yellow
            } else {
                banerColor = Color(hex: Constant.banerGreen)
                banerTitle = .green
            }
        }
    }
    
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
    
    init () {
        self.humiDatas = [("",17), ("",23), ("",24), ("",20), ("",22), ("",21), ("",17)]
        self.tempDatas = [("",17), ("",23), ("",24), ("",20), ("",22), ("",21), ("",17)]
        self.lightDatas = [("",17), ("",23), ("",24), ("",20), ("",22), ("",21), ("",17)]
        
        self.queryItems = [
        ]
        self.xDatas = [0.33, 0.15, 0.02, -0.15, 0.215, 0, 0.15, -0.15]
        self.yDatas = [0.02, -0.15, -0.15, 0.15, 0.3, 0, 0.14, 0.38]
        self.zDatas = [0.38, 0.14, 0, -0.12, -0.5, 0, 0.2, 0.3]
    }
    
    // MARK: - get list devices
    func getListDevices(completion: @escaping ((ListDeviceModel?) -> Void)) {
        ApiManager.shared.getListDevice {
            switch $0 {
            case let .success(listDevice):
                DispatchQueue.main.async {
                    completion(listDevice)
                }
            case let .failure(err):
                printError(err.localizedDescription)
            }
        }
    }
    
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
    func getTelemetry(complitionTemp: @escaping ((Int) -> Void),
                      complitionHumi: @escaping ((Int) -> Void),
                      complitionLight: @escaping ((Int) -> Void)) {
        ApiManager.shared.getTelemetry(telemetry: "temp") {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.temp = telemetry?.value ?? 0
                    complitionTemp(self.temp)
                }
            case let .failure(err):
                DispatchQueue.main.async {
                    self.temp = 7
                }
                print("failed")
                print(err.localizedDescription)
            }
        }
        
        ApiManager.shared.getTelemetry(telemetry: "humi") {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.humi = telemetry?.value ?? 0
                    complitionHumi(self.humi)
                }
            case let .failure(err):
                DispatchQueue.main.async {
                    self.humi = 17
                }
                print("failed")
                print(err.localizedDescription)
            }
        }
        
        ApiManager.shared.getTelemetry(telemetry: "light") {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.light = telemetry?.value ?? 0
                    complitionLight(self.light)
                }
            case let .failure(err):
                DispatchQueue.main.async {
                    self.light = 27
                }
                print("failed")
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: - get location
    func getLocation(complition: @escaping ((Int) -> Void)) {
        transportDatas = []
        ApiManager.shared.getTelemetry(telemetry: "location") {
            switch  $0 {
            case let .success(location):
                guard let location = location?.value else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.currentLocation = location
                    self.objectWillChange.send()
                }
                complition(location)
                
            case let .failure(err):
                DispatchQueue.main.async {
                    self.temp = 7
                }
                print("failed")
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: -  post Query location
    func postQueryLocation(location: Int = 1, complition: @escaping(() -> Void)) {
        let body =  APIConstant.getBodyLocation(location: location)
        ApiManager.shared.postQuery(body: body) {
            switch $0 {
            case let .success(locations):
                print(location)
                
                if self.isFirstTime {
                    self.isFirstTime = false
                    DispatchQueue.main.async {
                        self.locationDatas = []
                    }
                    self.timeLoop = location
                }
                
                if var locationItem = locations?.results?.last {
                    DispatchQueue.main.async {
                        locationItem.name = self.mockItems[location - 1].name
                        locationItem.location = location
                        self.objectWillChange.send()
                        self.locationDatas.append(locationItem)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.locationDatas.append(self.locationDatas[location - 1])
                        self.locationDatas[location].location = location
                    }
                }
                
                self.timeLoop += 1
                
                if self.timeLoop <= self.currentLocation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.postQueryLocation(location: self.timeLoop, complition: complition)
                    }
                } else {
                    let mockItems = PositionModel.mockItems()
                    DispatchQueue.main.async {
                        for i in self.timeLoop...mockItems.count {
                            self.locationDatas.append(mockItems[i-1])
                        }
                    }
                }
                
            case let .failure(err):
                printDebug("faild, body: \(body)")
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: - post query detail location
    func postQueryDetailLocation(location: Int = 1) {
        self.tempDatas = []
        self.humiDatas = []
        printDebug("location: \(location)")
        let body =  APIConstant.getBodyLocation(location: location, number: 10, time: TelemetryViewModel.times[1], day: 7)
        ApiManager.shared.postQuery(body: body) {
            switch $0 {
            case let .success(locations):
                let data = locations?.results ?? []
                DispatchQueue.main.async {
                    for item in data {
                        let time: String = convertToDate(string: item.time)
                        self.tempDatas.append((time, item.temp ?? 0))
                        self.humiDatas.append((time, item.humi ?? 0))
                    }
                }
            case let .failure(err):
                self.tempDatas = []
                self.humiDatas = []
                printDebug("faild, body: \(body)")
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: -  post Query xyz
    func postQueryAccel(body: String = APIConstant.getBodyAccel(number: 60, time: TelemetryViewModel.times[1], day: 1)) {
        ApiManager.shared.postQuery(body: body) {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.queryItems = telemetry?.results ?? []
                    self.xDatas = []
                    self.yDatas = []
                    self.zDatas = []
                    for item in self.queryItems {
                        self.xDatas.append(item.x ?? 0)
                        self.yDatas.append(item.y ?? 0)
                        self.zDatas.append(item.z ?? 0)
                    }
                }
            case let .failure(err):
                printDebug("faild, body: \(body)")
                DispatchQueue.main.async {
                    self.xDatas = [0.33, 0.15, 0.02, -0.15, 0.215, 0, 0.15, -0.15]
                    self.yDatas = [0.02, -0.15, -0.15, 0.15, 0.3, 0, 0.14, 0.38]
                    self.zDatas = [0.38, 0.14, 0, -0.12, -0.5, 0, 0.2, 0.3]
                }
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: -  post Query temp, humi, light
    func postQuery(body: String = APIConstant.getBody(number: 60, time: TelemetryViewModel.times[1], day: 1)) {
        ApiManager.shared.postQuery(body: body) {
            switch  $0 {
            case let .success(telemetry):
                DispatchQueue.main.async {
                    self.queryItems = telemetry?.results ?? []
//                    self.tempItems = self.queryItems.map({ $0.temp ?? 0 })
                    self.tempDatas = []
                    self.humiDatas = []
                    self.lightDatas = []
                    for item in self.queryItems {
                        let time: String = convertToDate(string: item.time)
                        self.tempDatas.append((time, item.temp ?? 0))
                        self.humiDatas.append((time, item.humi ?? 0))
                        self.lightDatas.append((time, item.light ?? 0))
                    }
                }
            case let .failure(err):
                printDebug("faild, body: \(body)")
                DispatchQueue.main.async {
                    self.humiDatas = [("",17), ("",23), ("",24), ("",20), ("",22), ("",21), ("",17)]
                    self.tempDatas = [("",17), ("",23), ("",24), ("",20), ("",22), ("",21), ("",17)]
                    self.lightDatas = [("",17), ("",23), ("",24), ("",20), ("",22), ("",21), ("",17)]
                }
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

public func convertToTimeArrived(string: String) -> String {
    let timeString = string
    let dateFomatter = DateFormatter()
    dateFomatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFomatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = dateFomatter.date(from: timeString)
    
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "HH:mm:ss MM-dd-yyyy"
    dateFormatter1.timeZone = TimeZone.current
    let stringConverted = dateFormatter1.string(from: date ?? Date())
    return stringConverted
}
