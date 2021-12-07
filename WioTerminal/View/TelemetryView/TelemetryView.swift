//
//  TelemetryView.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import SwiftUI
import SwiftUICharts

struct TelemetryView: View {
    @EnvironmentObject var wio: Wio
    var device: Device? {
        return wio.devices.first(where: {$0.isTracking})
    }
    
    @StateObject var viewModel = TelemetryViewModel()
    @State private var isShowDeviceView = false
    
    @State private var viewDidLoad: Bool = true
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .top)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Hi, Hust")
                                    .font(.custom(Font.nunutiBold, size: 40))
                                    .foregroundColor(Color(hex: Constant.greyColor))
                                Text("Chào mừng bạn quay trở lại")
                                    .font(.custom(Font.nunutiBold, size: 15))
                                    .foregroundColor(Color(hex: Constant.greyColor))
                            }
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 7)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(Color(hex: Constant.paletteRedColor1))
                                
                                Text("BK")
                                    .foregroundColor(.white)
                                    .font(.custom(Font.nunutiBold, size: 18))
                            }
                            .padding(.trailing, 10)
                        }
                        .padding()
                        .padding(.horizontal, 10)
                        
                        //MARK: - Change Baner
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "2a9d8f"))
                                .frame(width: 40, height: 20)
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            viewModel.banerColor = Color(hex: Constant.banerGreen)
                                            viewModel.banerTitle = .green
                                        }
                                )
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "EDAE49"))
                                .frame(width: 40, height: 20)
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            viewModel.banerColor = Color(hex: Constant.banerYellow)
                                            viewModel.banerTitle = .yellow
                                        }
                                )
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "D1495B"))
                                .frame(width: 40, height: 20)
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            viewModel.banerColor = Color(hex: Constant.banerRed)
                                            viewModel.banerTitle = .red
                                        }
                                )
                        }
                        .padding(.horizontal, 30)
                        
                        // MARK: -  BanerView
                        BanerView(viewModel: self.viewModel, connectionString: "đã kết nối", statusString: "bảo quản tốt")
                        
                        HStack {
                            Spacer()
                            Text("Điều kiện bảo quản tốt nhất cho sản phẩm của bạn cần là giữ liên tục trong kho lạnh ở nhiệt độ từ 4ᵒC đến 6ᵒC.")
                                .font(.custom(Font.nunitoRegular, size: 15))
                                .foregroundColor(Color(hex: Constant.greyColor))
                                .padding(.horizontal, 25)
                                .offset(y: 15)
                            Spacer()
                        }
                        .padding(.top, -15)
                        
                        HStack {
                            Spacer()
                            Text("Thông tin kho lạnh")
                                .font(.custom(Font.nunitoBoldItalic, size: 13))
                                .foregroundColor(Color(hex: Constant.greyColor))
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 13, height: 13)
                        }
                        .padding(.horizontal, 35)
                        
                        HStack {
                            BarChartView(data: ChartData(values: viewModel.tempDatas), title: "Nhiệt độ", legend: Constant.doC, style: Styles.barChartStyleOrangeLight, form: ChartForm.medium, dropShadow: false)
                            Spacer()
                            BarChartView(data: ChartData(values: viewModel.humiDatas), title: "Độ ẩm",legend: "%RH", style: Styles.barChartStyleNeonBlueLight, form: ChartForm.medium, dropShadow: false)
                        }
                        .padding(.horizontal, 30)
                        .offset(y: 5)
                        
                        Form {
                            Section(header: Text("Lịch sử")) {
                                Toggle(isOn: $viewModel.specialRequestEnabled.animation()) {
                                    Text("Đặt lại thông số biểu đồ")
                                        .font(.custom(Font.nunitoRegular, size: 18))
                                        .foregroundColor(Color.black)
                                }
                                
                                if viewModel.specialRequestEnabled {
                                    Picker("Khoảng cách giữa 2 điểm", selection: $viewModel.number) {
                                        ForEach(0..<TelemetryViewModel.numbers.count, id: \.self) {
                                            Text("\(TelemetryViewModel.numbers[$0])")
                                        }
                                    }
                                    
                                    Picker("Đơn vị thời gian", selection: $viewModel.time) {
                                        ForEach(0..<TelemetryViewModel.times.count, id: \.self) {
                                            Text("\(TelemetryViewModel.times[$0])")
                                        }
                                    }
                                    
                                    Picker("Trong vòng ngày ", selection: $viewModel.day) {
                                        ForEach(0..<TelemetryViewModel.days.count, id: \.self) {
                                            Text("\(TelemetryViewModel.days[$0])")
                                            
                                        }
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Button {
                                            let number = TelemetryViewModel.numbers[viewModel.number]
                                            let time = TelemetryViewModel.times[viewModel.time]
                                            let day = TelemetryViewModel.days[viewModel.day]
                                            
                                            let body = APIConstant.getBody(number: number, time: time, day: day)
                                            viewModel.postQuery(body: body)
                                        } label: {
                                            Text("Phân tích")
                                                .font(.custom(Font.nunitoBoldItalic, size: 18))
                                                .foregroundColor(Color(hex: Constant.paletteRedColor))
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .foregroundColor(Color(hex: Constant.greyColor))
                        }
                        .frame(height: 350)
                        .offset(y: -20)
                        .background(Color(hex: Constant.backgroundColor))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.queryItems, id: \.self ) { item in
                                    GeometryReader { geo in
                                        HistoryView(temp: item.temp ?? 0,
                                                    humi: item.humi ?? 0,
                                                    time: convertToHour(string: item.time))
                                    }
                                    .frame(width: 122)
                                }
                            }
                        }
                        .frame(height: 133)
                        .padding(.horizontal)
                        .offset(y: -250 + viewModel.offsetY)
                        
                        Spacer()
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
            .navigationTitle("Wio Terminal")
        }
        .onChange(of: device, perform: { newValue in
            viewDidLoad = true
        })
        .onAppear {
            getTelemetry()
            if viewDidLoad {
                viewDidLoad = false
                viewModel.postQuery()
                getListDevices()
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
    
    private func getListDevices() {
        viewModel.getListDevices { listDevice in
            if let devices = listDevice?.value {
                for device in devices {
                    if let _ = self.wio.devices.firstIndex(where: {$0.name == device.displayName}) {
                        
                    } else {
                        let data = Device()
                        data.name = device.displayName
                        data.templateID = device.template
                        DispatchQueue.main.async {
                            self.wio.add(data)
                        }
                    }
                }
            }
        }
        
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        TelemetryView()
    }
}
