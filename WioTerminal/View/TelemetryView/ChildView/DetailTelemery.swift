//
//  DetailTelemery.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/22/21.
//

import SwiftUI
import SwiftUICharts

enum DetailType: String {
    case temp
    case humi
    case light
    case acccel
    case location
}

struct DetailTelemery: View {
    @ObservedObject var viewModel = TelemetryViewModel()
    var navigationTitle = DetailType.temp
    private var location: Int = 1
    private var titleString = ""
    
    init (viewModel: TelemetryViewModel,
          navigationTitle: DetailType,
          location: Int = 1
    ) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        switch navigationTitle {
        case .temp:
            titleString = "Nhiệt độ"
        case .humi:
            titleString = "Độ ẩm"
        case .light:
            titleString = "Ánh sáng"
        case .acccel:
            titleString = "Chuyển động"
        case .location:
            titleString = "Quá trình vận chuyển"
        }
        self.location = location
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    
                    switch navigationTitle {
                    case .temp:
                        BarChartView(data: ChartData(values: viewModel.tempDatas), title: titleString, style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
                    case .humi:
                        BarChartView(data: ChartData(values: viewModel.humiDatas), title: titleString, style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
                    case .light:
                        BarChartView(data: ChartData(values: viewModel.lightDatas), title: titleString, style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
                    case .acccel:
                        MultiLineChartView(data: [(viewModel.xDatas, GradientColors.green), (viewModel.yDatas, GradientColors.purple), (viewModel.zDatas, GradientColors.orngPink)], title: "", form: ChartForm.extraLarge)
                    case .location:
                        BarChartView(data: ChartData(values: viewModel.tempDatas), title: "Nhiệt độ", style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
                            .padding(.bottom)
                        Spacer()
                        BarChartView(data: ChartData(values: viewModel.humiDatas), title: "Độ ẩm", style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
                    }
                    
                    if navigationTitle != .location {
                        Form {
                            Section(header: Text("Cài đặt")) {
                                Toggle(isOn: $viewModel.specialRequestEnabled.animation()) {
                                    Text("Đặt lại thông số biểu đồ")
                                        .font(.custom(Font.nunitoRegular, size: 17))
                                        .foregroundColor(Color.black)
                                }
                                
                                if viewModel.specialRequestEnabled {
                                    Picker("Khoảng cách giữa 2 điểm", selection: $viewModel.number) {
                                        ForEach(0..<TelemetryViewModel.numbers.count, id: \.self) {
                                            Text("\(TelemetryViewModel.numbers[$0])")
                                                .font(.custom(Font.nunitoLight, size: 16))
                                                .foregroundColor(Color(hex: Constant.greyColor))
                                        }
                                    }
                                    
                                    Picker("Đơn vị thời gian", selection: $viewModel.time) {
                                        ForEach(0..<TelemetryViewModel.times.count, id: \.self) {
                                            Text("\(TelemetryViewModel.times[$0])")
                                                .font(.custom(Font.nunitoLight, size: 16))
                                                .foregroundColor(Color(hex: Constant.greyColor))
                                        }
                                    }
                                    
                                    Picker("Trong vòng ngày ", selection: $viewModel.day) {
                                        ForEach(0..<TelemetryViewModel.days.count, id: \.self) {
                                            Text("\(TelemetryViewModel.days[$0])")
                                                .font(.custom(Font.nunitoLight, size: 16))
                                                .foregroundColor(Color(hex: Constant.greyColor))
                                        }
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Button  {
                                            let number = TelemetryViewModel.numbers[viewModel.number]
                                            let time = TelemetryViewModel.times[viewModel.time]
                                            let day = TelemetryViewModel.days[viewModel.day]
                                            
                                            let body = APIConstant.getBody(number: number, time: time, day: day)
                                            if navigationTitle == .location {
                                                viewModel.postQueryDetailLocation(location: self.location)
                                            } else {
                                                viewModel.postQuery(body: body)
                                            }
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
                    }
                    Spacer()
                }
            }
            .navigationTitle(titleString)
        }
        .onAppear {
            if navigationTitle == .location {
                viewModel.postQueryDetailLocation(location: self.location)
            }
        }
    }
}

struct DetailTelemery_Previews: PreviewProvider {
    static var previews: some View {
        DetailTelemery(viewModel: TelemetryViewModel(), navigationTitle: .temp)
    }
}
