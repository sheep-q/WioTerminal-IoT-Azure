//
//  ProfileViewModel.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import Foundation

class ProfileViewModel: ObservableObject {
    var profiles: [ProfileModel] = []
    
    init() {
        self.profiles.append(ProfileModel(title: "Giảng viên hướng dẫn", image: "coYen", text: "PGS.TS Phạm Thị Ngọc Yến", description: "Viện Điện - Đo lường, Tin học và Công nghiệp"))
        self.profiles.append(ProfileModel(title: "Giảng viên hướng dẫn", image: "thayTung", text: "TS.Nguyễn Việt Tùng", description: "Viện Phó Viện Mica"))
        self.profiles.append(ProfileModel(title: "Sinh viên thực hiện", image: "sv", text: "Nguyễn Văn Quang - 20174138", description: "KTĐK & TĐH 06"))
    }
}
