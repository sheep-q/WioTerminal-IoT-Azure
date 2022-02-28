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
        self.profiles.append(ProfileModel(title: "Giảng viên hướng dẫn", image: "coYen", text: "GS.TS Phạm Thị Ngọc Yến", description: "Viện Điện - Bộ môn Kỹ Thuật Đo và Tin Học Công Nghiệp"))
        self.profiles.append(ProfileModel(title: "Giảng viên hướng dẫn", image: "thayTung", text: "TS.Nguyễn Việt Tùng", description: "Viện nghiên cứu quốc tế và truyền thông Mica"))
        self.profiles.append(ProfileModel(title: "Sinh viên thực hiện", image: "sv", text: "Nguyễn Văn Quang - 20174138", description: "KTĐK & TĐH 06"))
    }
}
