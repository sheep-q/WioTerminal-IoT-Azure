//
//  AddNewDeviceView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 30/11/2021.
//

import SwiftUI

struct EditDeviceView: View {
    @EnvironmentObject var wio: Wio
    
    @State private var name: String
    @State private var templateID: String
    @State private var product: Product = Product()
    @State private var roldeID: String
    @State private var ruleTempLow: Double
    @State private var ruleTempHigh: Double
    @State private var ruleHumiLow: Double
    @State private var ruleHumiHigh: Double
    @State private var isShowingAlert: Bool = false
    
    var device: Device
    
    let products: [Product] = [
        Product(name: "Phô mai", image: "milk"),
        Product(name: "Hải sản đông lạnh", image: "milk"),
        Product(name: "Vắc-xin", image: "milk"),
        Product(name: "Sữa tươi", image: "milk"),
        Product(name: "Sữa tuyệt trùng", image: "milk")
    ]
    
    init(device: Device) {
        self.device = device
        self.name = device.name
        self.templateID = device.templateID
        self.product = device.product
        self.roldeID = device.roleID
        self.ruleTempLow = device.rule.ruleTempLow
        self.ruleTempHigh = device.rule.ruleTempHigh
        self.ruleHumiLow = device.rule.ruleHumiLow
        self.ruleHumiHigh = device.rule.ruleHumiHigh
    }
    
    var body: some View {
//        NavigationView {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .all)
                VStack {
                    Form {
                        Section(header: Text("Thiết bị")) {
                            HStack {
                                Text("Tên của thiết bị:")
                                Spacer()
                                Text(name)
                                    .foregroundColor(Color(hex: Constant.greyColor))
                            }
                            
                            HStack {
                                Text("Template ID:")
                                Spacer()
                                Text(templateID)
                                    .foregroundColor(Color(hex: Constant.greyColor))
                            }
                            
                            Picker("Loại Sản phẩm", selection: $product) {
                                ForEach(self.products, id: \.self) {
                                    Text($0.name)
                                }
                            }
                        }
                        
                        Section(header: Text("Điều kiện nhiệt độ")) {
                            HStack {
                                Text("Giá trị nhỏ nhất")
                                Stepper("\(ruleTempLow, specifier: "%.2f") \(Constant.doC)", value: $ruleTempLow, in: -10...50, step: 0.5)
                            }
                            HStack {
                                Text("Giá trị nhỏ nhất")
                                Stepper("\(ruleTempHigh, specifier: "%.2f") \(Constant.doC)", value: $ruleTempHigh, in: -10...50, step: 0.5)
                            }
                        }
                        
                        Section(header: Text("Điều kiện độ ẩm")) {
                            HStack {
                                Text("Giá trị nhỏ nhất")
                                Stepper("\(ruleHumiLow, specifier: "%.2f") %RH", value: $ruleHumiLow, in: 0...100, step: 5)
                            }
                            HStack {
                                Text("Giá trị nhỏ nhất")
                                Stepper("\(ruleHumiHigh, specifier: "%.2f") %RH", value: $ruleHumiHigh, in: 0...100, step: 5)
                            }
                        }
                    }
                    
                    if #available(iOS 15.0, *) {
                        Button(action: {
                            isShowingAlert = true
                            let device = Device()
                            device.name = name
                            device.templateID = templateID
                            device.product = product
                            device.rule.ruleTempLow = ruleTempLow
                            device.rule.ruleTempHigh = ruleTempHigh
                            device.rule.ruleHumiLow = ruleHumiLow
                            device.rule.ruleHumiHigh = ruleHumiHigh
                            self.wio.edit(device)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 7)
                                    .frame(width: 180, height: 40)
                                    .foregroundColor(Color(hex: "D1495B"))
                                
                                Text("Lưu")
                                    .foregroundColor(.white)
                                    .font(.custom(Font.nunitoRegular, size: 20))
                            }
                        }
                        .offset(y: -100)
                        .alert("Đã lưu thành công", isPresented: $isShowingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    Spacer()
                }
            }
    }
}

