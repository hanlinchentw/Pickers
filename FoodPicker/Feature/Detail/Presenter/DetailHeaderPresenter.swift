//
//  DetailHeaderViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/11.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import Foundation
import Combine
import ImageSlideshow

protocol DetailHeaderDelegate : AnyObject {
	func handleDismissDetailPage()
	func handleLikeRestaurant()
	func handleShareRestaurant()
	func pushToSlideShowVC()
}

class DetailHeaderPresenter {
	var delegate: DetailHeaderDelegate?
	var detail : Detail?
	@Published var isLiked: Bool
	var imageSource: Array<AlamofireSource>
	init(isLiked: Bool, detail: Detail?, imageSource: Array<AlamofireSource>) {
		self.detail = detail
		self.isLiked = isLiked
		self.imageSource = imageSource
	}
	
	var likeButtonImageName: String {
		return isLiked ? "btnBookmarkHeartPressed" : "btnBookmarkHeartDefault"
	}
	
	func dismissDetailPage(){
		delegate?.handleDismissDetailPage()
	}
	func likeButtonTapped(){
		delegate?.handleLikeRestaurant()
	}
	
	func shareButtonTapped(){
		delegate?.handleShareRestaurant()
	}
	
	func pushToSlideShowController() {
		delegate?.pushToSlideShowVC()
	}
}
