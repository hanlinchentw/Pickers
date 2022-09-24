//
//  SearchListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct SearchListView: View, Selectable {
	@Inject var selectService: SelectedCoreService

	@ObservedObject var vm: SearchListViewModel
	@EnvironmentObject var coordinator: MainCoordinator
	@Environment(\.managedObjectContext) private var viewContext
	@FetchRequest(sortDescriptors: []) var selectedRestaurants: FetchedResults<SelectedRestaurant>

	var body: some View {
		ZStack {
			Color.listViewBackground
			if vm.isSearching {
				ProgressView()
					.progressViewStyle(.circular)
					.foregroundColor(.butterScotch)
			} else {
				VStack {
					Button {
						withAnimation {
							vm.isSearching = false
							vm.searchText = ""
							vm.searchState = .idle
						}
					} label: {
						Text("Clean search results")
							.foregroundColor(.butterScotch)
					}
					.frame(width: 170, height: 44)
					.buttonStyle(.plain)

					ScrollView(showsIndicators: false) {
						VStack(spacing: 16) {
							ForEach(vm.viewObjects.indices, id: \.self) { index in
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
						.padding(.trailing, 8)
						.padding(.top, 16)
						.background(Color.white)
						.cornerRadius(24)
					}
					Spacer()
				}
				
			}
		}
		.ignoresSafeArea()
	}
}

struct SearchListView_Previews: PreviewProvider {
	static var previews: some View {
		SearchListView(vm: MockSearchListViewModel())
	}
}

class MockSearchListViewModel: SearchListViewModel {
	override init() {
		super.init()
		viewObjects = MockedRestaurant.TEST_RESTAURANT_VIEW_OBJECT_ARRAY + MockedRestaurant.TEST_RESTAURANT_VIEW_OBJECT_ARRAY
	}
}
