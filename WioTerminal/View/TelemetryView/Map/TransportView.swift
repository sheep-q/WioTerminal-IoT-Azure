//
//  TransportView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 07/12/2021.
//

import SwiftUI

struct TransportView: View {
    @ObservedObject var viewModel = TelemetryViewModel()
    var body: some View {
        ZStack {
            Color(hex: Constant.backgroundColor)
                .ignoresSafeArea()
            List {
                ForEach(viewModel.transportDatas, id: \.self) { data in
                    Text("\(data.name)")
                        .foregroundColor(data.location <= viewModel.currentLocation ? Color(hex: Constant.banerRed) : Color(hex: Constant.greyColor))
                }
            }
        }
        .onAppear {
            viewModel.getLocation { currentLocation in
                viewModel.isFirstTime = true 
                viewModel.postQueryLocation(location: 1) {
                    
                }
            }
//            let group = DispatchGroup()
//            for i in 1...8 {
//                group.enter()
//                viewModel.postQueryLocation(body: APIConstant.getBodyLocation(location: i)) { item in
//                    print(item)
//                    print("request \(i)")
//                    group.leave()
//
//
//                }
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {}
//            }
//            group.notify(queue: DispatchQueue.main) {
//                print("done")
//            }
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
