//
//  ContentView.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import SwiftUI

struct ContentView: View {
    var wio = Wio()
    var body: some View {
        TabView {
            TelemetryView()
                .tabItem {
                    Image(systemName: "house")
                    Text("First View")
                }
            
            MonitorView()
                .tabItem {
                    Image(systemName: "cloud")
                    Text("Zero View")
                }
            
            ThirdView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Third View")
                }
        }
        .environmentObject(wio)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
