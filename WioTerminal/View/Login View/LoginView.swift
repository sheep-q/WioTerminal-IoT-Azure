//
//  LoginView.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 01/12/2021.
//

import SwiftUI

struct LoginView: View {
    
    @State private var subDomain = ""
    @State private var baseDomain = ""
    @State private var authorizationString = ""
    @State private var isShowingTabBarView = false
    //    @State private var subDomain = "wioterminal"
    //    @State private var  baseDomain = "azureiotcentral.com"
    //    @State private var  authorizationString = "SharedAccessSignature sr=c5c95af8-b0b7-44d3-b0e8-800f72170fc5&sig=3TsHAwNRAHSDeitDA%2BdtlLD8jw9aSgwBNeoAtm%2FsI3A%3D&skn=token&se=1669434747676"
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //                Color(hex: Constant.backgroundColor)
                //                    .ignoresSafeArea(.all)
                Color.white
                VStack {
                    Image("logoHust")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                    
                    Image("wio")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .cornerRadius(30)
                        .offset()
                    
                    VStack(alignment: .leading) {
                        NeumorphicStyleTextField(textField: TextField("Sub domain", text: $subDomain))
                            .padding(.top, 10)
                        NeumorphicStyleTextField(textField: TextField("Base domain", text: $baseDomain))
                            .padding(.top, 10)
                        NeumorphicStyleTextField(textField: TextField("Key Authorization", text: $authorizationString))
                            .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 40)
                    Spacer()
                    
                    if #available(iOS 15.0, *) {
                        Button(action: {
                            isShowingTabBarView = true
                        }) {
                            
                            Text("Đăng nhập")
                                .foregroundColor(.white)
                                .font(.custom(Font.nunitoRegular, size: 20))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 50)
                                .background(Color(hex: "D1495B"))
                                .cornerRadius(10)
                        }
//                        .alert("Đã lưu thành công", isPresented: $isShowingAlert) {
//                            Button("OK", role: .cancel) { }
//                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    Spacer()
                    Spacer()
                }
                .fullScreenCover(isPresented: $isShowingTabBarView) {
                    TabBarView()
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
