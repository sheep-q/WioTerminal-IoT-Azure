//
//  BanerView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//

import SwiftUI

struct BanerView: View {
    @EnvironmentObject var wio: Wio
    var device: Device? {
        return wio.devices.first(where: {$0.isTracking})
    }
    
    @State private var phase: CGFloat = 0
    @State var connectionString: String
    @State var statusString: String
    @ObservedObject var viewModel: TelemetryViewModel
    @State var isShowDetail = false
    @State var isShowingEditDeviceView = false
    
    init (viewModel: TelemetryViewModel,
          connectionString: String,
          statusString: String
    ) {
        self.viewModel = viewModel
        self.connectionString = connectionString
        self.statusString = statusString
    }
    
    var body: some View {
        //NavigationView{
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(viewModel.banerColor)
                    .frame(height: 300)
                    .shadow(color: .gray, radius: 5, x: -2, y: 2)
                    .padding(.horizontal, 30)
                
                
                VStack {
                    HStack {
                        Image("check")
                            .resizable()
                            .scaleEffect()
                            .frame(width: 25, height: 25)
                        
                        Text("đã kết nối")
                            .foregroundColor(.white)
                            .font(.custom("Nunito-Regular", size: 20))
                    }
                    .padding(.bottom, -2)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 170, height: 45)
                        
                        HStack {
                            Image(device?.product.image ?? "vaccine")
                                .resizable()
                                .scaleEffect()
                                .frame(width: 30, height: 30)
                            
                            Text(" \(viewModel.banerTitle.rawValue)" )
                                .foregroundColor(Color(hex: Constant.greyColor))
                                .font(.custom("Nunito-Regular", size: 20))
                        }
                    }
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                isShowingEditDeviceView = true
                            }
                    )
                    
                    .padding(.bottom, 15)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                            .frame(width: 270, height: 150)
                        
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [10], dashPhase: phase))
                            .frame(width: 270, height: 150)
                            .foregroundColor(viewModel.banerColor)
                            .onAppear {
                                withAnimation(.linear.repeatForever(autoreverses: false)) {
                                    phase -= 20
                                    if phase < -40 {
                                        phase = 0
                                    }
                                }
                            }
                        
                        VStack {
                            Image("tempHumi")
                                .resizable()
                                .scaleEffect()
                                .frame(width: 40, height: 40)
                            ZStack {
                                
                                Rectangle()
                                    .frame(width: 1, height: 25)
                                    .foregroundColor(Color(hex: Constant.greyColor))
                                    .padding(.horizontal, 30)
                                
                                HStack(alignment: .center) {
                                    
                                    VStack {
                                        Text("\(viewModel.temp)")
                                            .font(.custom(Font.nunitoRegular, size: 35))
                                            .foregroundColor(viewModel.tempColor)
                                        + Text("°C")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        
                                        Text("nhiệt độ")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.leading, 120)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("\(viewModel.humi)")
                                            .font(.custom(Font.nunitoRegular, size: 35))
                                            .foregroundColor(viewModel.humiColor)
                                        + Text("%RH")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        
                                        Text("độ ẩm")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.trailing, 105)
                                }
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            isShowingEditDeviceView = true
                                        }
                                )
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowDetail) {
                DetailBanerView()
            }
            .sheet(isPresented: $isShowingEditDeviceView) {
                getTelemetry()
            } content: {
                EditDeviceView(device: device ?? Device())
            }
    }
    
    private func getTelemetry() {
        viewModel.getTelemetry(complitionTemp: { value in
            if let rule = device?.rule {
                if value < Int (rule.ruleTempLow) - 5 || value > Int(rule.ruleTempHigh) + 5 {
                    viewModel.tempColor = Color(hex: Constant.banerRed)
                } else if value > Int(rule.ruleTempLow) && value < Int(rule.ruleTempHigh) {
                    viewModel.tempColor = Color(hex: Constant.banerGreen)
                } else {
                    viewModel.tempColor = Color(hex: Constant.banerYellow)
                }
            }
        }, complitionHumi: { value in
            if let rule = device?.rule {
                if value < Int (rule.ruleHumiLow) - 5 || value > Int(rule.ruleHumiHigh) + 5 {
                    viewModel.humiColor = Color(hex: Constant.banerRed)
                } else if value > Int(rule.ruleHumiLow) && value < Int(rule.ruleHumiHigh) {
                    viewModel.humiColor = Color(hex: Constant.banerGreen)
                } else {
                    viewModel.humiColor = Color(hex: Constant.banerYellow)
                }
            }
        }, complitionLight: { value in
            
        })
    }
}

struct BanerView_Previews: PreviewProvider {
    static var previews: some View {
        BanerView(viewModel: TelemetryViewModel(),
                  connectionString: "đã kết nối",
                  statusString: "bảo quản tốt")
    }
}
