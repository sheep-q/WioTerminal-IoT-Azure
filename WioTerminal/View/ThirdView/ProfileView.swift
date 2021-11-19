//
//  ProfileView.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import SwiftUI

struct ProfileView: View {
    
    let image: String
    let text: String
    let description: String
    let width: CGFloat
    let title: String
    
    var body: some View {
        
        ZStack {
            Color(hex: Constant.profileBackgroundColor)
                .frame(width: 350, height: 520)
                .cornerRadius(25)
            VStack{
                
                Image("logoHust")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(Color.white)
                    .cornerRadius(10)
                
                Text(title)
                    .padding(.bottom)
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Image(image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: width)
                    .overlay(Circle().stroke(Color(hex: "ff9f1c"), lineWidth: 7))
                
                Text(text)
                    .font(.headline)
                    .padding(.top)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .opacity(0.6)
            }
        }
            
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(image: "sv",
                    text: "Nguyễn Văn Quang",
                    description: "KT&DK TDH 06",
                    width: 250,
                    title: "Sinh viên thực hiện")
    }
}
