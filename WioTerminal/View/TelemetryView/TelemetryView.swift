//
//  TelemetryView.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import SwiftUI
import SwiftUICharts

struct TelemetryView: View {
    
    @StateObject var viewModel = TelemetryViewModel()
    @State var viewDidLoad = false
    
    init(){
        UITableView.appearance().backgroundColor = .clear
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
                                Text("Wellcome back, I'm Wio Terminal")
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
                        
                        // MARK: -  BanerView
                        BanerView(viewModel: self.viewModel, connectionString: "đã kết nối", statusString: "bảo quản tốt")
                        
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
            .navigationTitle("Wio Terminal")
        }
        .onAppear {
            if !viewDidLoad {
                print("Load")
                viewDidLoad = true
                viewModel.getTelemetry()
                viewModel.postQuery()
                //viewModel.postQuery(body: "SELECT MAX(temp), AVG(temp), MAX(humi), MAX(light) FROM dtmi:modelDefinition:jyf9vhwxe:jar8rfo1yh WHERE WITHIN_WINDOW(P4D) AND temp > 0 GROUP BY WINDOW(PT10M) ORDER BY $ts ASC")
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        TelemetryView()
    }
}
