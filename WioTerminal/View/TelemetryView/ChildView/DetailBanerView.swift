//
//  DetailBanerView.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/25/21.
//

import SwiftUI

struct DetailBanerView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image("milkbg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text("""
Các loại sữa chua uống, yogourt,.. nên trữ lạnh và dùng trong thời hạn ghi trên hộp, cần được bảo quản liên tục trong kho lạnh bảo quản ở nhiệt độ từ 4ᵒC đến 6ᵒC.

- “Trên thị trường sữa hiện nay có 2 loại sữa đó là sữa tươi thanh trùng và sữa tươi tiệt trùng.”
Sữa tươi thanh trùng được đóng gói trong trai nhựa hoặc hộp giấy có thời gian sử dụng ngắn từ 3 đến 5 ngày với điều kiện sữa luôn được bảo quản trong kho lạnh bảo quản có nhiệt độ từ 0oC đến 5oC thì sẽ sẽ không bị hỏng.

   Sữa tươi tiệt trùng là loại sữa được đựng trong hộp giấy, có thể sử dụng luôn mà không cần bảo quản trong kho lạnh. Nhưng khi đã mở nắp hộp giấy ra thì phải sử dụng hết trong vòng 48 giờ. Nếu sữa được vắt ra và chỉ được đun sôi nấu tiệt trùng ở gia đình thì chỉ có thể sử dụng trong 24 giờ.

https://www.bachhoaxanh.com/kinh-nghiem-hay/cach-bao-quan-cac-loai-sua-1012909

Sữa chua bắt buộc phải được giữ ở nhiệt độ thấp của tủ lạnh. Điều này là bởi nếu được để ở nhiệt độ bình thường, vi khuẩn axit lactic trong sữa chua sẽ không được kiểm soát và phát triển nhanh chóng mặt, chúng lên men tự do với đường sữa trong sữa chua, làm cho sữa chua ngày càng chua hơn và hương vị không còn ngon nữa
""")
                        .padding()
                        .layoutPriority(1)
                }
            }
        }
        .navigationBarTitle(Text("Bảo quản sữa"), displayMode: .inline)
    }
}

struct DetailBanerView_Previews: PreviewProvider {
    static var previews: some View {
        DetailBanerView()
    }
}
