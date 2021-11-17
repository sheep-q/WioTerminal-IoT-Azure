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
        ZStack {
            
            Color.pink            
            Text("\(viewModel.temp)")
        }
        .onAppear {
            ApiManager.shared.getTelemetry(telemetry: "temp") {
                switch  $0 {
                case let .success(telemetry):
                    print("success")
                    print(telemetry.value)
                case let .failure(err):
                    print("failed")
                    print(err.localizedDescription)
                }
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        TelemetryView()
    }
}
