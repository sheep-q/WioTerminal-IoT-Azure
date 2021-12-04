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
                    Image(systemName: "house")
                    Text("First View")
                }
            
            MonitorView()
                .tabItem {
                    Image(systemName: "command.square.fill")
                    Text("Zero View")
                }
            
            SettingView()
                .tabItem {
                    Image(systemName: "cloud.fill")
                    Text("Zero View")
                }
            
            ThirdView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Third View")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
