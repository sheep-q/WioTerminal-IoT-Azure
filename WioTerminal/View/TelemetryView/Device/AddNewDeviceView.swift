//
//  AddNewDeviceView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 30/11/2021.
//

import SwiftUI

struct AddNewDeviceView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wio: Wio
    
    @State private var name: String = ""
    @State private var templateID: String = ""
    @State private var product: Product = Product()
    @State private var roldeID: String = ""
    @State private var ruleTempLow: Double = 4
    @State private var ruleTempHigh: Double = 6
    @State private var ruleHumiLow: Double = 10
    @State private var ruleHumiHigh: Double = 20
    
    let products: [Product] = [
        Product(name: "Phô mai", image: "milk"),
        Product(name: "Hải sản đông lạnh", image: "milk"),
        Product(name: "Vắc-xin", image: "milk"),
        Product(name: "Sữa tươi", image: "milk"),
        Product(name: "Sữa tuyệt trùng", image: "milk")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .all)
                VStack {
                    Form {
                        Section(header: Text("Thiết bị")) {
                            TextField("Tên của thiết bị", text: $name)
                            TextField("Template ID", text: $templateID)
                            
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
                    
                    Button(action: {
                        let device = Device()
                        device.name = name
                        device.templateID = templateID
                        device.product = product
                        device.rule.ruleTempLow = ruleTempLow
                        device.rule.ruleTempHigh = ruleTempHigh
                        device.rule.ruleHumiLow = ruleHumiLow
                        device.rule.ruleHumiHigh = ruleHumiHigh
                        self.wio.add(device)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .frame(width: 180, height: 40)
                                .foregroundColor(Color(hex: "D1495B"))
                            
                            Text("Kết nối")
                                .foregroundColor(.white)
                                .font(.custom(Font.nunitoRegular, size: 20))
                        }
                    }
                    .padding(.top, 50)
                }
            }
            .navigationTitle("Thêm mới thiết bị")
        }
    }
}

