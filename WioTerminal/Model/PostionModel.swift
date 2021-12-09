//
//  PostionModel.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 07/12/2021.
//

import Foundation

struct PositionModel: Identifiable, Hashable {
    var id = UUID()
    var temp: Double?
    var humi: Double?
    var time: Double?
    var name: String
    var location: Int
    var check: Bool = false
    
    static func mock() -> [PositionModel] {
        var data = [PositionModel]()
        data = [
            PositionModel(id: UUID(), name: "Đơn hàng xuất kho, Thành Phố Hồ Chí Minh",location: 1),
            PositionModel(id: UUID(), name: "Thành phố Nha Trang",location: 2),
            PositionModel(id: UUID(), name: "Thành phố Đà Nẵng",location: 3),
            PositionModel(id: UUID(), name: "Thành phố Huế",location: 4),
            PositionModel(id: UUID(), name: "Thành phố Thanh Hoá",location: 5),
            PositionModel(id: UUID(), name: "Thành phố Nam Định",location: 6),
            PositionModel(id: UUID(), name: "Bến xe Giáp Bát",location: 7),
            PositionModel(id: UUID(), name: "Đại học Bách Khoa Hà Nội",location: 8),
        ]
        return data
    }
}
