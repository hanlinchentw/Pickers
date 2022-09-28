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
	func pushToSlideShowVC(photos: Array<AlamofireSource>)
}

class DetailHeaderPresenter {
	var delegate: DetailHeaderDelegate?
	var detail : Detail?
	@Published var isLiked: Bool
	
	init(isLiked: Bool, detail: Detail?) {
		self.detail = detail
		self.isLiked = isLiked
	}
	
	var imageUrl: [URL] {
		if let photos = detail?.photos, !photos.isEmpty {
			return photos
		}
		
		if let imageUrl = detail?.imageUrl {
			return [URL(string: imageUrl) ?? URL(string: Constants.defaultImageURL)!]
		}
		
		return []
	}
	
	var imageSource: Array<AlamofireSource> {
		let source = imageUrl.map { AlamofireSource(url: $0) }
		return source
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
	
	func pushToSlideShowController(photos: Array<AlamofireSource>) {
		delegate?.pushToSlideShowVC(photos: photos)
	}
}
