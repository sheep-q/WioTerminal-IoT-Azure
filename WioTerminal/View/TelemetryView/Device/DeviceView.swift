//
//  DeviceView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 30/11/2021.
//

import SwiftUI

struct DeviceView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wio: Wio
    
    @State private var isShowingAddNewDevice = false
    @State private var isShowingEditDevice = false
    
    @StateObject var viewModel = TelemetryViewModel()
    
    var devices: [Device] {
        return wio.devices
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea(edges: .all)
                VStack {
                    HStack {
                        Text("Vuốt để chọn")
                            .font(.custom(Font.nunitoRegular, size: 15))
                            .foregroundColor(Color(hex: Constant.greyColor))
                        Image(systemName: "arrow.forward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        Spacer()
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        Text("Vuốt để xoá, sửa")
                            .font(.custom(Font.nunitoRegular, size: 15))
                            .foregroundColor(Color(hex: Constant.greyColor))
                    }
                    .padding(.horizontal, 20)
                    .offset(y: 35)
                    ScrollViewReader { proxy in
                    List {
                        ForEach(devices) { device in
                            if #available(iOS 15.0, *) {
                                NavigationLink(destination: EditDeviceView(device: device)) {
                                    if device.isTracking {
                                        Image("check")
                                            .resizable()
                                            .scaleEffect()
                                            .frame(width: 25, height: 25)
                                    }
                                    Text(device.name)
                                        .foregroundColor(Color.black)
                                    Spacer()
                                    Text(device.product.name)
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                }
                                .swipeActions(allowsFullSwipe: false) {
                                    Button {
                                        isShowingEditDevice = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil.circle.fill")
                                    }
                                    .tint(.indigo)
                                    
                                    Button(role: .destructive) {
                                        wio.delete(device.name)
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        wio.toggle(device)
                                    } label: {
                                        Label("Add", systemImage: "checkmark.circle.fill")
                                    }
                                    .tint(.indigo)
                                }
                            } else {
                                // NA
                            }
                        }
                    }
                    }
                }
                .sheet(isPresented: $isShowingEditDevice) {
                    AddNewDeviceView()
                }
                .navigationTitle("Chọn thiết bị")
                .navigationBarItems(trailing: Button(action: {
                    self.isShowingAddNewDevice = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(hex: "D1495B"))
                        
                        Text("+")
                            .foregroundColor(.white)
                            .font(.custom(Font.nunutiBold, size: 20))
                    }
                })
                .sheet(isPresented: $isShowingAddNewDevice) {
                    AddNewDeviceView()
                }
                
                .navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(hex: "D1495B"))
                        
                        Image(systemName: "arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 13, height: 13)
                            .foregroundColor(Color.white)
                    }
                })
            }
            .onAppear {
                //viewModel.getListDevices()
            }
        }
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
    }
}
