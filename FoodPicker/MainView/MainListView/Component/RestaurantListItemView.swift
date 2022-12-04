//
//  RestaurantListItemView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct RestaurantListItemView: View {
	var presenter: RestaurantPresenter
	
	var actionButtonOnPress: () -> Void
	
	init(presenter: RestaurantPresenter, actionButtonOnPress: @escaping () -> Void) {
		self.presenter = presenter
		self.actionButtonOnPress = actionButtonOnPress
	}
	var body: some View {
		HStack {
			if let imageUrl = presenter.imageUrl {
				CachedAsyncImage(url: imageUrl) { phase in
					switch phase {
					case .empty:
						Color.gray.opacity(0.5)
					case .success(let image):
						image
							.resizable()
					case .failure(_):
						Image(systemName: "exclamationmark.icloud")
					@unknown default:
						Image(systemName: "exclamationmark.icloud")
					}
				}
				.aspectRatio(contentMode: .fill)
				.frame(width: 93, height: 93)
				.cornerRadius(16)
				.padding(.top, 8)
				.padding(.leading, 8)
			}

			VStack(alignment: .leading) {
				VStack(alignment: .leading, spacing: 6) {
					Text(presenter.name).en16Bold()
					if let priceCategoryDistanceText = presenter.priceCategoryDistanceText {
						Text(priceCategoryDistanceText).en14()
					}
				}
				
				if let rating = presenter.ratingWithOneDecimal,
					 let reviewCount = presenter.reviewCount {
					HStack(spacing: 4, content: {
						Text("★").foregroundColor(Color.yellow)
						Text("\(rating)").en14()
						Text("\(reviewCount)").en14()
							.foregroundColor(Color.gray.opacity(0.7))
						Spacer()
					})
				}
			}
			.padding(.leading, 16)
			
			Spacer()

			Button {
				actionButtonOnPress()
			} label: {
				Image(presenter.actionButtonImage)
					.shadow(color: Color.gray.opacity(0.25), radius: 3, x: 0, y: 0)
					.animation(.easeInOut(duration: 0.25), value: presenter.actionButtonImage)
			}
			.frame(width: 40, height: 40)
		}
		.frame(width: UIScreen.screenWidth - 16, height: 102)
	}
}
