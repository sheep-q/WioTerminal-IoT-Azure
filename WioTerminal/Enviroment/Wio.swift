//
//  Wio.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 30/11/2021.
//

import Foundation

class Device: Identifiable, Codable {
    let id = UUID()
    var name = "Wio Terminal"
    var templateID = ""
    var roleID = ""
    var product: Product = Product()
    var rule: Rule = Rule()
    fileprivate(set) var isTracking = false
}

struct Rule: Codable, Hashable {
    var ruleTempLow: Double = 0
    var ruleTempHigh: Double = 0
    var ruleHumiLow: Double = 0
    var ruleHumiHigh: Double = 0
}

struct Product: Codable, Hashable {
    var name: String = ""
    var image: String = ""
}

class Wio: ObservableObject {
    @Published private(set) var devices: [Device]
    static let saveKey = "SavedData"
    
    init() {
        
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Device].self, from: data) {
                self.devices = decoded
                return
            }
        }

        self.devices = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(devices) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func add(_ device: Device) {
        devices.append(device)
        save()
    }
    
    func edit(_ device: Device) {
        if let indexth = devices.firstIndex(where: {$0.name == device.name}) {
            devices[indexth].rule = device.rule
            devices[indexth].product = device.product
            save()
            objectWillChange.send()
        }
    }
    
    func delete(_ deviceName: String) {
        if let indexth = devices.firstIndex(where: {$0.name == deviceName}) {
            devices.remove(at: indexth)
            save()
        }
    }
    
    func toggle(_ device: Device) {
        _ = devices.map({$0.isTracking = false})
        device.isTracking.toggle()
        save()
        objectWillChange.send()
    }
}
