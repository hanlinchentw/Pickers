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
			if vm.searchState == .searching {
				ProgressView()
					.progressViewStyle(.circular)
					.foregroundColor(.butterScotch)
			} else if vm.searchState == .done {
				LazyVStack(spacing: 16) {
					ScrollView(showsIndicators: false) {
						ForEach(0 ..< vm.viewObjects.count, id: \.self) { index in
							let restaurant = vm.viewObjects[index]
							let isSelected = selectedRestaurants.contains(where: { $0.id == restaurant.id })
							let actionButtonMode: ActionButtonMode = isSelected ? .select : .deselect
							let presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)
							
							RestaurantListItemView(
								presenter: presenter,
								actionButtonOnPress: {
									selectRestaurant(isSelected: isSelected, restaurant: restaurant)
								})
							.onTapGesture {
								coordinator.pushToDetailView(id: restaurant.id)
							}
							.buttonStyle(.plain)
						}
					}
					.coordinateSpace(name: "MoreRestaurantScrollView")
					.padding(.trailing, 8)
					.padding(.top, 16)
					.background(Color.white)
					.cornerRadius(24)
				}
			} else if vm.searchState == .error {
				errorView
			}
		}
		.ignoresSafeArea()
	}
	
	var errorView: some View {
		VStack {
			Text("I'm sorry ... 🥲")
				.en24Bold()
				.foregroundColor(.black)
			Text("We can't find a match of\n'\(vm.searchText)'\nTry searching for something else instead.")
				.en16()
				.multilineTextAlignment(.center)
				.lineSpacing(2)
				.foregroundColor(.gray.opacity(0.5))
				.padding(.top, 16)
			Image("illustrationSearchXresult")
				.frame(width: 320, height: 320)
		}
		.padding(.top, 44)
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
