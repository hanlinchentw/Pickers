////
////  DetailHeaderViewModel.swift
////  FoodPicker
////
////  Created by 陳翰霖 on 2020/11/11.
////  Copyright © 2020 陳翰霖. All rights reserved.
////
//
//import Foundation
//struct DetailHeaderViewModel{
//    let restaurant : Restaurant
//    var detail : Details?
//    init(restaurant: Restaurant) {
//        self.restaurant = restaurant
//        if let detail = restaurant.details {
//            self.detail = detail
//        }
//    }
//    //MARK: - Header
//       var imageUrl : [URL]? {
//           guard let photos = detail?.photos else {
//               return [restaurant.imageUrl]
//           }
//           return photos
//       }
//       var likeButtonImageName: String {
//           return restaurant.isLiked ? "btnBookmarkHeartPressed" : "btnBookmarkHeartDefault"
//       }
//}
