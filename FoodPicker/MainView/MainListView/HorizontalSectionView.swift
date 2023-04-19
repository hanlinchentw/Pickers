//
//  PopularSectionView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct HorizontalSectionView<ViewModel>: View where ViewModel: MainListViewModelProtocol {
	@ObservedObject var vm: ViewModel
	@EnvironmentObject var coordinator: FeedCoordinator

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			if (vm.loadingState != .error) {
				Text("Top choices")
					.en24Bold()
					.padding(.leading, 16)
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						ForEach(0 ..< vm.dataCount, id: \.self) { index in
							if vm.loadingState != LoadingState.loaded {
								DummyRestaurantCardView().padding(.vertical, 8)
							} else {
								let restaurant = vm.viewObjects[index]
								
								let isLiked = false
								let isSelected = false
								
								let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
								let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode, isLiked: isLiked)
								
								RestaurantCardView(presenter: presenter) {
									
								} _: {
									
								}
								.onTapGesture {
									coordinator.pushToDetailView(id: restaurant.id)
								}
								.padding(.vertical, 8)
							}
						}
						.padding(.leading, 16)
					}
				}
			}
		}
	}
	
	
}
