//
//  TabBarView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 03/12/2021.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var wio: Wio
    
    var body: some View {
        TabView {
            TelemetryView()
                .tabItem {
                    Image(systemName: "display")
                    Text("Theo dõi")
                }
            
            MonitorView()
                .tabItem {
                    Image(systemName: "rectangle.grid.2x2")
                    Text("Điều khiển")
                }
            
            if wio.isAdmin {
                SettingView()
                    .tabItem {
                        Image(systemName: "wrench.and.screwdriver.fill")
                        Text("Cài đặt")
                    }
            }
            
            ThirdView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Thông tin")
                }
        }
        .accentColor(Color(hex: Constant.banerRed))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
