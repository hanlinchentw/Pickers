//
//  PopularSectionView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct HorizontalSectionView: View, Selectable, Likable {
	@Inject var selectService: SelectedCoreService
	@Inject var likeService: LikedCoreService
	
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
  @FetchRequest(sortDescriptors: []) var likedRestaurants: FetchedResults<LikedRestaurant>
	let section: MainListSection
	@ObservedObject var vm = MainListSectionViewModel()

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
			if (vm.loadingState != .error) {
				Text(section.description)
          .en24Bold()
          .padding(.leading, 16)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 16) {
						ForEach(0 ..< vm.dataCount, id: \.self) { index in
							if vm.loadingState != LoadingState.loaded {
								DummyRestaurantCardView().padding(.vertical, 8)
							} else {
								let restaurant = vm.viewObjects[index]

								let isLiked = likedRestaurants.contains(where: {$0.id == restaurant.id})
								let isSelected = selectedRestaurants.contains(where: {$0.id == restaurant.id})

								let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
								let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode, isLiked: isLiked)

								RestaurantCardView(presenter: presenter) {
									selectRestaurant(isSelected: isSelected, restaurant: restaurant)
								} _: {
									likeRestaurant(isLiked: isLiked, restaurant: restaurant)
								}
								.onTapGesture {
									coordinator.pushToDetailView(id: restaurant.id)
								}
								.padding(.vertical, 8)
							}
						}
          }
          .padding(.leading, 16)
        }
      }
    }
		.task {
			if vm.loadingState == .loaded { return }
			await vm.fetchData(section: section)
		}
  }
}
