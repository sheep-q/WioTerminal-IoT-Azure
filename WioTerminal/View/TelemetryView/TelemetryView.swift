//
//  TelemetryView.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import SwiftUI

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
                        
                        BanerView(temp: 5, humi: 30, connectionString: "đã kết nối", statusString: "bảo quản tốt")
                        
                        HStack {
                            Text("Lịch sử 10p trước")
                                .foregroundColor(Color(hex: Constant.greyColor))
                                .font(.custom(Font.nunutiBold, size: 20))
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .offset(y: 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<10) { index in
                                    GeometryReader { geo in
                                        HistoryView()
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
        }
        .onAppear {
            viewModel.getTelemetry()
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        TelemetryView()
    }
}
