//
//  TransportViewRow.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 10/12/2021.
//

import SwiftUI

struct TransportViewRow: View {
    
    @State var location: Int
    @State var temp: Int?
    @State var humi: Int?
    @State var time: String?
    @State var currentLocation: Int
    @State var nameLocation: String
    
    init(location: Int?, temp: Double?, humi: Double?, time: String?, currentLocation: Int, nameLocation: String?) {
        self.location = location ?? 0
        self.temp = Int(temp ?? 0)
        self.humi = Int(humi ?? 0)
        self.time = time
        self.currentLocation = currentLocation
        self.nameLocation = nameLocation ?? "Error"
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 120)
                .foregroundColor(Color.white)
                .cornerRadius(25)
            
            VStack{
                HStack {
                    if location <= currentLocation {
                        Image("box")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        Text(nameLocation)
                            .font(.custom(Font.nunutiBold, size: 17))
                            .foregroundColor(Color(hex: Constant.banerGreen))
                            .padding(.leading)
                            .lineLimit(2)
                        Spacer()

                    } else if location == currentLocation + 1 {
                        Image("delivering")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        Text(nameLocation)
                            .font(.custom(Font.nunutiBold, size: 17))
                            .foregroundColor(Color(hex: Constant.banerRed))
                            .padding(.leading)
                            .lineLimit(2)
                        Spacer()
                        Text("...đang đến")
                            .font(.custom(Font.nunitoRegular, size: 13))
                            .foregroundColor(Color(hex: Constant.banerRed))
                            .offset(y: 5)
                    } else if location > currentLocation + 1 {
                        Image("coming")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        Text(nameLocation)
                            .font(.custom(Font.nunutiBold, size: 17))
                            .foregroundColor(Color(hex: Constant.greyColor))
                            .padding(.leading)
                            .lineLimit(2)
                        Spacer()

                    }
                }
                .offset(y: 8)
                                
                Divider()
                
                HStack{
                    Spacer()
                    Text(time ?? "")
                        .foregroundColor(Color(hex: Constant.greyColor))
                        .font(.custom(Font.nunitoRegular, size: 13))
                }
                
                VStack {
                    ZStack {
                        Image("tempHumi")
                            .resizable()
                            .scaleEffect()
                            .frame(width: 25, height: 25)
                        
                        HStack(alignment: .center) {
                            
                            VStack {
                                if let temp = temp {
                                    Text("\(temp)")
                                        .font(.custom(Font.nunitoRegular, size: 20))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                    + Text("°C")
                                        .font(.custom(Font.nunitoRegular, size: 13))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                } else {
                                    Text("_")
                                        .font(.custom(Font.nunitoRegular, size: 20))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                    + Text("°C")
                                        .font(.custom(Font.nunitoRegular, size: 13))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                }

                            }
                            .padding(.leading, 100)
                            
                            Spacer()
                            
                            VStack {
                                if let humi = humi {
                                    Text("\(humi)")
                                        .font(.custom(Font.nunitoRegular, size: 20))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                    + Text("%RH")
                                        .font(.custom(Font.nunitoRegular, size: 13))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                } else {
                                    Text("_")
                                        .font(.custom(Font.nunitoRegular, size: 20))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                    + Text("%RH")
                                        .font(.custom(Font.nunitoRegular, size: 13))
                                        .foregroundColor(Color(hex: Constant.greyColor))
                                }
                            }
                            .padding(.trailing, 85)
                        }
                    }
                }
                .offset(y: -10)
                
            }
            .padding(.horizontal, 20)
        }
    }
}
