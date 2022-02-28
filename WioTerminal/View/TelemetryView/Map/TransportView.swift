//
//  TransportView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 07/12/2021.
//

import SwiftUI

struct TransportView: View {
    
    @ObservedObject var viewModel = TelemetryViewModel()
    @State var currentLocation: Int = 0
    @State var isPushToView = false
    @State var viewDidLoad = true
    @State var isShowAlert = false
    
    var body: some View {
        if #available(iOS 15.0, *) {
            ZStack {
                Color(hex: Constant.backgroundColor)
                    .ignoresSafeArea()
                VStack {
                    List {
                        ForEach(viewModel.locationDatas, id: \.self) { data in
                            NavigationLink {
                                DetailTelemery(viewModel: self.viewModel, navigationTitle: .location, location: data.location ?? 0)
                            } label: {
                                if #available(iOS 15.0, *) {
                                    TransportViewRow(location: data.location,
                                                     temp: data.temp,
                                                     humi: data.humi,
                                                     time: convertToTimeArrived(string: data.time),
                                                     currentLocation: viewModel.currentLocation,
                                                     nameLocation: data.name)
                                        .listRowSeparator(.hidden)
                                        .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                                } else {
                                    TransportViewRow(location: data.location,
                                                     temp: data.temp,
                                                     humi: data.humi,
                                                     time: convertToTimeArrived(string: data.time),
                                                     currentLocation: viewModel.currentLocation,
                                                     nameLocation: data.name)
                                        .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                                }
                            }
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .opacity(viewModel.requestBuzzerCommandAlert == .requesting ? 0.5 : 1)
                }
            }
            .navigationBarItems(trailing: Button(action: {
                isShowAlert.toggle()
            }) {
                Image("delivering")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            })
            .alert("Xác nhận đã đến vị trí tiếp theo", isPresented: $isShowAlert) {
                Button("Xác nhận", role: .cancel) {
                    viewModel.requestBuzzerCommandAlert = .requesting
                    viewModel.postBuzzerCommand(body: "777")
                }
                Button("Huỷ", role: .destructive) {
                    // nil
                }
            }
            .alert("Đã cập nhập. Tải lại quá trình vận chuyển", isPresented: $viewModel.isShowingBuzzerCommandAlert) {
                Button("OK", role: .cancel) {
                    viewModel.requestBuzzerCommandAlert = .notRequest
                    viewModel.getLocation { currentLocation in
                        self.currentLocation = currentLocation
                        viewModel.isFirstTime = true
                        viewModel.postQueryLocation(location: 1) {
                        }
                    }
                }
            }
            .onAppear {
                if viewDidLoad == true {
                    viewDidLoad = false
                    viewModel.getLocation { currentLocation in
                        self.currentLocation = currentLocation
                        viewModel.isFirstTime = true
                        viewModel.postQueryLocation(location: 1) {
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

struct TransportView_Previews: PreviewProvider {
    static var previews: some View {
        TransportView()
    }
}
