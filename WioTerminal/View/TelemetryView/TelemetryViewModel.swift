//
//  TelemetryViewModel.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 17/11/2021.
//

import Foundation

class TelemetryViewModel: ObservableObject {
    @Published var temp: Int = 0
    @Published var humi: Int = 0
    @Published var light: Int = 0
    @Published var soil: Int = 0
    
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
    }
}
