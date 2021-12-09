//
//  DeliveryView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 07/12/2021.
//

import SwiftUI
import MapKit

struct DeliveryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isPushToView = false
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination:
                   TransportView(),
                   isActive: $isPushToView) {
                     EmptyView()
                }.hidden()
                
                MapView()
                    .ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    Button {
                        isPushToView = true
                    } label: {
                        Text("Quá trình vận chuyển")
                            .font(.custom(Font.nunutiBold, size: 20))
                            .foregroundColor(Color.white)
                            .padding()
                            .padding(.horizontal, 30)
                            .background(Color(hex: Constant.banerRed))
                            .cornerRadius(15)
                    }

                }
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
    }
}

struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryView()
    }
}
