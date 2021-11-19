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
                            Text("Lịch sử 10p trước")
                                .foregroundColor(Color(hex: Constant.greyColor))
                                .font(.custom(Font.nunutiBold, size: 20))
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        HStack {
                            BarChartView(data: ChartData(values: viewModel.tempDatas), title: "Nhiệt độ", legend: Constant.doC, style: Styles.barChartStyleOrangeLight, form: ChartForm.medium, dropShadow: false)
                            BarChartView(data: ChartData(values: viewModel.humiDatas), title: "Độ ẩm",legend: "%RH", style: Styles.barChartStyleNeonBlueLight, form: ChartForm.medium, dropShadow: false)
                        }
                        .padding(.horizontal)
                        
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
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Wio Terminal")
            .onAppear {
                viewModel.getTelemetry()
                viewModel.postQuery(body: "SELECT MAX(temp), AVG(temp), MAX(humi), MAX(light) FROM dtmi:modelDefinition:jyf9vhwxe:jar8rfo1yh WHERE WITHIN_WINDOW(P1D) AND temp > 0 GROUP BY WINDOW(PT10M) ORDER BY $ts ASC")
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        TelemetryView()
    }
}
