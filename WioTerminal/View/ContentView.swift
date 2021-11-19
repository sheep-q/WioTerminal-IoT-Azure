//
//  ContentView.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
