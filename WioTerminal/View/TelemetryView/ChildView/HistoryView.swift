//
//  HistoryView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .frame(width: 120, height: 130)
                .padding(.horizontal)
                .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
            
            Text("15h.30")
                .font(.custom(Font.nunitoLight, size: 13))
                .foregroundColor(.black)
            
            VStack {
                Spacer()
                Text("5°C")
                    .font(.custom(Font.nunitoRegular, size: 20))
                    .foregroundColor(.black)
                    .offset(x: -30)
                
                Spacer().frame(height: 45)
                
                Text("30%RH")
                    .font(.custom(Font.nunitoRegular, size: 20))
                    .foregroundColor(.black)
                    .offset(x: 15)
                Spacer()
            }
        }
    }
}

struct historyView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
