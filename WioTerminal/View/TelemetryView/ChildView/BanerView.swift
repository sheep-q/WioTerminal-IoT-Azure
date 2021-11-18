//
//  BanerView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//

import SwiftUI

struct BanerView: View {
    
    @State private var phase: CGFloat = 0
    @State var temp: Int
    @State var humi: Int
    @State var connectionString: String
    @State var statusString: String
    
    init (temp: Int,
          humi: Int,
          connectionString: String,
          statusString: String
    ) {
        self.temp = temp
        self.humi = humi
        self.connectionString = connectionString
        self.statusString = statusString
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: Constant.paletteGreenColor))
                .frame(height: 300)
                .padding(.horizontal)
                .shadow(color: .gray, radius: 5, x: -2, y: 2)
                .padding(.horizontal, 30)
            
            
            VStack {
                HStack {
                    Image("check")
                        .resizable()
                        .scaleEffect()
                        .frame(width: 25, height: 25)
                    
                    Text("đã kết nối")
                        .foregroundColor(.white)
                        .font(.custom("Nunito-Regular", size: 20))
                }
                .padding(.bottom, -2)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 220, height: 45)
                    
                    HStack {
                        Image("milk")
                            .resizable()
                            .scaleEffect()
                            .frame(width: 30, height: 30)
                        
                        Text("bảo quản tốt")
                            .foregroundColor(Color(hex: Constant.greyColor))
                            .font(.custom("Nunito-Regular", size: 20))
                    }
                }
                
                .padding(.bottom, 15)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                        .frame(width: 250, height: 150)
                    
                    RoundedRectangle(cornerRadius: 15)
                               .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [10], dashPhase: phase))
                               .frame(width: 250, height: 150)
                               .foregroundColor(Color(hex: "2EC4B6"))
                               .onAppear {
                                   withAnimation(.linear.repeatForever(autoreverses: false)) {
                                       phase -= 20
                                       if phase < -40 {
                                           phase = 0
                                       }
                                   }
                               }
                    
                    VStack {
                        Image("tempHumi")
                            .resizable()
                            .scaleEffect()
                            .frame(width: 40, height: 40)
                        ZStack {
                            
                            Rectangle()
                                .frame(width: 1, height: 25)
                                .foregroundColor(Color(hex: Constant.greyColor))
                                .padding(.horizontal, 30)
                            
                            HStack(alignment: .center) {
                                
                                VStack {
                                    Text("\(temp)°C")
                                        .font(.custom(Font.nunitoRegular, size: 20))
                                        .foregroundColor(.black)
                                    
                                    Text("nhiệt độ")
                                        .font(.custom(Font.nunitoRegular, size: 15))
                                        .foregroundColor(.black)
                                }
                                .padding(.leading, 120)
                                
                                Spacer()
                                
                                VStack {
                                    Text("\(humi)%RH")
                                        .font(.custom(Font.nunitoRegular, size: 20))
                                        .foregroundColor(.black)
                                    
                                    Text("độ ẩm")
                                        .font(.custom(Font.nunitoRegular, size: 15))
                                        .foregroundColor(.black)
                                }
                                .padding(.trailing, 110)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct BanerView_Previews: PreviewProvider {
    static var previews: some View {
        BanerView(temp: 5,
                  humi: 30,
                  connectionString: "đã kết nối",
                  statusString: "bảo quản tốt")
    }
}
