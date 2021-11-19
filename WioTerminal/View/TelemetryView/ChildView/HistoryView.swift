//
//  HistoryView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//

import SwiftUI

struct HistoryView: View {
    
    @State var temp: Double
    @State var humi: Double
    @State var time: String
    
    init (temp: Double,
          humi: Double,
          time: String) {
        self.temp = temp
        self.humi = humi
        self.time = time
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .frame(width: 120, height: 130)
                .padding(.horizontal)
                .shadow(color: Color(hex: "e5e5e5"), radius: 2, x: -1, y: 1.5)
            
            Text(time)
                .font(.custom(Font.nunitoLight, size: 13))
                .foregroundColor(Color(hex: Constant.greyColor))
            
            VStack {
                Spacer()
                Text("\(Int(temp))\(Constant.doC)")
                    .font(.custom(Font.nunitoRegular, size: 20))
                    .foregroundColor(Color(hex: Constant.greyColor))
                    .offset(x: -30)
                
                Spacer().frame(height: 45)
                
                Text("\(Int(humi))%RH")
                    .font(.custom(Font.nunitoRegular, size: 20))
                    .foregroundColor(Color(hex: Constant.greyColor))
                    .offset(x: 15)
                Spacer()
            }
        }
    }
}

struct historyView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(temp: 0, humi: 0, time: "")
    }
}
