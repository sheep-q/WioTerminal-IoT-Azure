//
//  MonitorView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//

import SwiftUI
import SwiftUICharts

struct MonitorView: View {
    @ObservedObject var viewModel = TelemetryViewModel()
    private let width: CGFloat = 165
    private let height: CGFloat = 165
    @State private var speakerToggle = false
    @State private var lockToggle = false
    @State private var pumpToggle = false
    @State private var viewDidLoad = false
    
    @State var pushTempDetailViewActive = false
    @State var pushHumiDetailViewActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
//                NavigationLink(destination:
//                                BarChartView(data: ChartData(values: viewModel.datas), title: "Temperature", style: Styles.barChartStyleNeonBlueLight, form: ChartForm.extraLarge),
//                               isActive: self.$pushActive) {
//                    // NA
//                }.hidden()
                
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .top)
                
                ScrollView (.vertical, showsIndicators: false ) {
                    
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
                        .padding(.bottom)
                        
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
                        }.padding(.bottom)
                        
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
                        }.padding(.bottom)
                        
                        HStack {
                            // MARK: -  light
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
                }
            }
            .navigationTitle("Monitor")
        }
        .onAppear {
            if !viewDidLoad {
                print("Load")
                viewDidLoad = true
                viewModel.getTelemetry()
                viewModel.postQuery()
            }
        }
    }
}

struct MonitorView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorView(viewModel: TelemetryViewModel())
    }
}
