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
    var body: some View {
        ZStack {
            Color(hex: Constant.backgroundColor)
                .ignoresSafeArea()
            VStack {
                List {
                    ForEach(viewModel.locationDatas, id: \.self) { data in
                        if #available(iOS 15.0, *) {
                            ZStack {
                                NavigationLink(destination:
                                   TransportView(),
                                   isActive: $isPushToView) {
                                     EmptyView()
                                }.hidden()
                                
                            TransportViewRow(location: data.location,
                                             temp: data.temp,
                                             humi: data.humi,
                                             time: convertToTimeArrived(string: data.time),
                                             currentLocation: viewModel.currentLocation,
                                             nameLocation: data.name)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                            }
                        } else {
                            // Fallback on earlie r versions
                        }
                    }
                }
                .listStyle(SidebarListStyle())
            }
        }
        .onAppear {
            viewModel.getLocation { currentLocation in
                self.currentLocation = currentLocation
                viewModel.isFirstTime = true
                viewModel.postQueryLocation(location: 1) {
                }
            }
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
