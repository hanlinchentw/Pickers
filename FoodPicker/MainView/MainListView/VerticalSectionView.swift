//
//  VerticalRestaurantListContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct VerticalSectionView: View, Selectable {
	@Inject var selectService: SelectedCoreService
	@Inject var likeService: LikedCoreService
	
  @EnvironmentObject var coordinator: MainCoordinator
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>
	@ObservedObject var vm = MainListSectionViewModel()

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
			if vm.loadingState != .error {
        Text("Restaurant nearby")
          .en24Bold()
          .padding(.leading, 16)
        VStack(spacing: 16) {
					ForEach(0 ..< vm.dataCount, id: \.self) { index in
						if vm.loadingState != LoadingState.loaded {
              IdleRestaurantListItemView()
                .padding(.vertical, 8)
                .shimmer()
            } else {
							let restaurant = vm.viewObjects[index]
              let isSelected = selectedRestaurants.contains(where: {$0.id == restaurant.id})
              let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
              let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)
              
              RestaurantListItemView(presenter: presenter, actionButtonOnPress: {
								selectRestaurant(isSelected: isSelected, restaurant: restaurant)
              })
              .onTapGesture {
                coordinator.pushToDetailView(id: restaurant.id)
              }
              .buttonStyle(.plain)
            }
          }
          Button {
            coordinator.pushToMoreListView()
          } label: {
            HStack {
              Text("More restaurants")
                .foregroundColor(.black)
                .en16Bold()
              Image(systemName: "arrow.right")
                .foregroundColor(.butterScotch)
                .frame(width: 32, height: 32)
            }
          }
          .padding(.vertical, 16)
        }
        .padding(.top, 16)
        .background(Color.white)
        .cornerRadius(24)
        Spacer()
      }
    }
		.task {
			if vm.loadingState == .loaded { return }
			await vm.fetchData(section: .nearby)
		}
  }
}
