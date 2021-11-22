//
//  DetailTelemery.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/22/21.
//

import SwiftUI
import SwiftUICharts

struct DetailTelemery: View {
    @ObservedObject var viewModel = TelemetryViewModel()
    let navigationTitle: String
    
    init (viewModel: TelemetryViewModel,
          navigationTitle: String) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
    }
    var body: some View {
        NavigationView {
            VStack {
                BarChartView(data: ChartData(values: viewModel.tempDatas), title: navigationTitle, style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge)
                
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
            .navigationTitle(navigationTitle)
        }
    }
}

struct DetailTelemery_Previews: PreviewProvider {
    static var previews: some View {
        DetailTelemery(viewModel: TelemetryViewModel(), navigationTitle: "Nhiệt độ")
    }
}
