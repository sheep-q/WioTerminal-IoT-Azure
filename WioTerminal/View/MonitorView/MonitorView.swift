//
//  MonitorView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//

import SwiftUI
import SwiftUICharts

struct MonitorView: View {
    
    @EnvironmentObject var wio: Wio
    @ObservedObject var viewModel = TelemetryViewModel()
    
    private let width: CGFloat = 165
    private let height: CGFloat = 165
    @State private var speakerToggle = false
    @State private var lockToggle = false
    @State private var pumpToggle = false
    
    @State var pushTempDetailViewActive = false
    @State var pushHumiDetailViewActive = false
    
    @State private var isShowDeviceView = false
    var device: Device? {
        return wio.devices.first(where: {$0.isTracking})
    }
    
    @State private var showSafari = false
    @State private var urlString = "https://wioterminal.azureiotcentral.com/rules"
    @State private var viewDidLoad: Bool = true
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .top)
                
                ScrollView (.vertical, showsIndicators: false ) {
                    
                    VStack {
                        HStack {
                            Text("Bảng điều khiển")
                                .font(.custom(Font.nunutiBold, size: 25))
                                .foregroundColor(Color(hex: Constant.greyColor))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .offset(y: 10)
                        .hidden()
                        
                        VStack {
                            HStack {
                                // MARK: -  temp
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white)
                                        .frame(width: width, height: height)
                                        .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
                                    VStack {
                                        Image("temp")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40)
                                            .padding(10)
                                        
                                        Text("Nhiệt độ")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        
                                        Text("\(viewModel.temp)")
                                            .font(.custom(Font.nunitoRegular, size: 40))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        + Text("°C")
                                            .font(.custom(Font.nunitoRegular, size: 20))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                    }
                                }
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            pushTempDetailViewActive = true
                                        }
                                )
                                .sheet(isPresented: $pushTempDetailViewActive) {
                                    DetailTelemery(viewModel: self.viewModel, navigationTitle: .temp)
                                }
                                
                                Spacer()
                                
                                // MARK: -  humi
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white)
                                        .frame(width: width, height: height)
                                        .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
                                    
                                    VStack {
                                        Image("humi")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40)
                                            .padding(10)
                                        
                                        Text("Độ ẩm")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        
                                        Text("\(viewModel.humi)")
                                            .font(.custom(Font.nunitoRegular, size: 40))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        + Text("%RH")
                                            .font(.custom(Font.nunitoRegular, size: 20))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                    }
                                }
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            pushHumiDetailViewActive = true
                                        }
                                )
                                .sheet(isPresented: $pushHumiDetailViewActive) {
                                    DetailTelemery(viewModel: self.viewModel, navigationTitle: .humi)
                                }
                            }
                            .padding(.bottom, 7)
                            
                            HStack {
                                // MARK: -  light
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white)
                                        .frame(width: width, height: height)
                                        .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
                                    VStack {
                                        Image("light")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40)
                                            .padding(10)
                                        
                                        Text("Ánh sáng")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        
                                        Text("\(viewModel.light)")
                                            .font(.custom(Font.nunitoRegular, size: 40))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        + Text("%")
                                            .font(.custom(Font.nunitoRegular, size: 20))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                    }
                                }
                                
                                Spacer()
                                
                                // MARK: -  speaker
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white)
                                        .frame(width: width, height: height)
                                        .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
                                    
                                    VStack {
                                        Image("speaker")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40)
                                            .padding(10)
                                        
                                        Text("Phát nhạc")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        
                                        if #available(iOS 15.0, *) {
                                            ZStack {
                                                Toggle(isOn: $speakerToggle) {
                                                    Text("")
                                                }
                                                .offset(x: -65)
                                                .opacity(viewModel.requestBuzzerCommandAlert == .requesting ? 0 : 1)
                                                //.disabled(viewModel.requestBuzzerCommandAlert == .requesting ? true : false)
                                                .alert("Nhạc đã tắt", isPresented: $viewModel.isShowingBuzzerCommandAlert) {
                                                    Button("OK", role: .cancel) {
                                                        viewModel.requestBuzzerCommandAlert = .notRequest
                                                    }
                                                }
                                                
                                                Text("Đang phát nhạc...")
                                                    .font(.custom(Font.nunitoRegular, size: 13))
                                                    .foregroundColor(Color.green)
                                                    .opacity(viewModel.requestBuzzerCommandAlert == .requesting ? 1 : 0)
                                            }
                                        } else {
                                            // Fallback on earlier versions
                                            //printDebug("ios15 required")
                                        }
                                    }
                                }
                            }.padding(.bottom, 7)
                            
                            HStack {
                                // MARK: -  lock
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white)
                                        .frame(width: width, height: height)
                                        .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
                                    
                                    VStack {
                                        Image("lock")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40)
                                            .padding(10)
                                        
                                        Text("Chống trộm")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        
                                        Toggle(isOn: $lockToggle) {
                                            Text("")
                                        }
                                        .offset(x: -65)
                                    }
                                }
                                
                                Spacer()
                                
                                // MARK: -  pump
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white)
                                        .frame(width: width, height: height)
                                        .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
                                    
                                    VStack {
                                        Image("pump")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40)
                                            .padding(10)
                                        
                                        Text("Máy bơm")
                                            .font(.custom(Font.nunitoRegular, size: 15))
                                            .foregroundColor(Color(hex: Constant.greyColor))
                                        
                                        Toggle(isOn: $pumpToggle) {
                                            Text("")
                                        }
                                        .offset(x: -65)
                                    }
                                }
                            }.padding(.bottom, 7)
                            
                            HStack {
                                // MARK: -  +
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white)
                                        .frame(width: width, height: height)
                                        .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
                                    Text("+")
                                        .font(.custom(Font.nunutiBold, size: 50))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                }
                                
                                Spacer()
                                
                                // MARK: -  speaker
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white)
                                        .frame(width: width, height: height)
                                        .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
                                    
                                    Text("+")
                                        .font(.custom(Font.nunutiBold, size: 50))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                }
                                .alert(isPresented: $speakerToggle,
                                       TextAlert(title: "Thời lượng bật nhạc",
                                                 message: "Đơn vị giây(s)",
                                                 keyboardType: .numberPad) { result in
                                    if let time = result {
                                        viewModel.requestBuzzerCommandAlert = .requesting
                                        viewModel.postBuzzerCommand(body: time)
                                    } else {
                                        // The dialog was cancelled
                                        print("dissmiss")
                                    }
                                })
                                .opacity(0)
                            }.padding(.bottom)
                            // MARK: -  VStack
                        }
                        .padding(.horizontal, 38)
                        
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                self.isShowDeviceView = true
            }) {
                Text(device?.name ?? ".....")
                    .foregroundColor(Color(hex: "D1495B"))
                    .font(.custom(Font.nunutiBold, size: 18))
            })
            .fullScreenCover(isPresented: $isShowDeviceView, onDismiss: {
                getTelemetry()
                viewModel.postQuery()
            }, content: {
                DeviceView()
            })
            .navigationTitle("Bảng điều khiển")
        }
        .onChange(of: device, perform: { newValue in
            viewDidLoad = true
        })
        .onAppear {
            getTelemetry()
            if viewDidLoad {
                viewDidLoad = false
                viewModel.postQuery()
            }
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

struct MonitorView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorView(viewModel: TelemetryViewModel())
    }
}
