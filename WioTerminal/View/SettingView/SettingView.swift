//
//  CloudView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 03/12/2021.
//

import SwiftUI

struct SettingView: View {
    @State private var showSafari = false
    @State private var urlString = "https://wioterminal.azureiotcentral.com/rules"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .top)
                ScrollView (.vertical, showsIndicators: false ) {
                    VStack {
                        HStack {
                            Text("Đặt điều kiện")
                                .font(.custom(Font.nunutiBold, size: 25))
                                .foregroundColor(Color(hex: Constant.greyColor))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .offset(y: 10)
                        
                        ZStack {
                            
                            VStack {
                                Text("Đặt ra các điều kiện để khi chúng xảy ra, bạn sẽ nhận được thông báo qua Outlook")
                                    .font(.custom(Font.nunitoRegular, size: 15))
                                    .foregroundColor(Color(hex: Constant.greyColor))
                                Spacer()
                            }
                            .padding(.horizontal, 25)
                            
                            Form {
                                HStack {
                                    Text("Cài đặt điều kiện")
                                        .font(.custom(Font.nunitoRegular, size: 17))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                }
                                .onTapGesture {
                                    urlString = "https://wioterminalhust.azureiotcentral.com/rules"
                                    self.showSafari.toggle()
                                }
                            }
                            .frame(height: 130)
                            .offset(y: 20)
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Đặt lịch")
                                .font(.custom(Font.nunutiBold, size: 25))
                                .foregroundColor(Color(hex: Constant.greyColor))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .offset(y: 10)
                        
                        ZStack {
                            
                            VStack {
                                Text("Đặt các điều khiển theo lịch trình cụ thể.\nXem lịch sử các điều khiển đặt lịch đã được thực thi.")
                                    .font(.custom(Font.nunitoRegular, size: 15))
                                    .foregroundColor(Color(hex: Constant.greyColor))
                                Spacer()
                            }
                            .padding(.horizontal, 25)
                            
                            Form {
                                HStack {
                                    Text("Đặt lịch")
                                        .font(.custom(Font.nunitoRegular, size: 17))
                                    Spacer()
                                    Image(systemName: "chevron.forward.2")
                                }
                                .onTapGesture {
                                    urlString = "https://wioterminalhust.azureiotcentral.com/jobs/definitions/create/configure"
                                    self.showSafari.toggle()
                                }
                                
                                HStack {
                                    Text("Lịch sử điều khiển")
                                        .font(.custom(Font.nunitoRegular, size: 17))
                                    Spacer()
                                    Image(systemName: "chevron.forward.2")
                                }
                                .onTapGesture {
                                    urlString = "https://wioterminalhust.azureiotcentral.com/jobs/instances"
                                    self.showSafari.toggle()
                                }
                            }
                            .frame(height: 200)
                            .offset(y: 20)
                        }
                        
                        Spacer()
                    }
                }
            }
            .fullScreenCover(isPresented: $showSafari) {
                SafariView(url:URL(string: urlString)!)
            }
            .navigationTitle("Cài đặt")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
