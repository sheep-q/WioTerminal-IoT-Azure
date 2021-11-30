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
}

struct DetailTelemery: View {
    @ObservedObject var viewModel = TelemetryViewModel()
    var navigationTitle = DetailType.temp
    
    init (viewModel: TelemetryViewModel,
          navigationTitle: DetailType) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .top)
                VStack {
                    
                    switch navigationTitle {
                    case .temp:
                        BarChartView(data: ChartData(values: viewModel.tempDatas), title: "Nhiệt độ", style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
                    case .humi:
                        BarChartView(data: ChartData(values: viewModel.humiDatas), title: "Độ ẩm", style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
                    case .light:
                        Text("Light")
                    }
                    
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
                }
            }
            .navigationTitle(navigationTitle == .temp ? "Nhiệt độ" : "Độ ẩm")
        }
    }
}

struct DetailTelemery_Previews: PreviewProvider {
    static var previews: some View {
        DetailTelemery(viewModel: TelemetryViewModel(), navigationTitle: .temp)
    }
}
