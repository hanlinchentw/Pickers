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
			switch vm.searchState {
			case .searching:
				ProgressView()
					.progressViewStyle(.circular)
					.foregroundColor(.butterScotch)
			case .done(let result):
				switch result {
				case .success(let viewObjects):
					VStack {
						ScrollView(showsIndicators: false) {
							VStack(spacing: 16) {
								ForEach(viewObjects.indices, id: \.self) { index in
									let restaurant = viewObjects[index]
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
				case .failure(_):
					errorView
				}
			case .idle:
				Spacer().height(0)
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
