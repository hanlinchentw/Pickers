//
//  MainListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import CoreData
import Toast_Swift
import CoreLocation
import Combine

enum LoadingState {
	case idle
	case loading
	case loaded
	case error
}

struct MainListView<ViewModel>: View where ViewModel: MainListViewModelProtocol {
	@ObservedObject var viewModel: ViewModel
	
	var body: some View {
		ZStack {
			Color.listViewBackground.ignoresSafeArea()
			ScrollView {
				VStack(spacing: 24) {
					VStack {
						HorizontalSectionView(vm: viewModel)
					}
				}
			}
			.refreshable {
				try? await viewModel.fetchData()
			}
			.onAppear {
				viewModel.refresh()
			}
		}
		.navigationBarHidden(true)
		.onTapToResign()
	}
	
	var emptyView: some View {
		Button {
			viewModel.refresh()
		} label: {
			HStack {
				Text("Please try again")
					.en16()
					.foregroundColor(.black.opacity(0.6))
				Image(systemName:"arrow.triangle.2.circlepath")
					.frame(width: 56, height: 56)
					.foregroundColor(.butterScotch)
			}
		}
	}
}

struct MainListView_Previews: PreviewProvider {
	static var previews: some View {
		let mockViewModel = MockViewModel(.empty)
		return MainListView(viewModel: mockViewModel)
	}
}

class MockViewModel: MainListViewModelProtocol {
	enum MockType {
		case loading
		case loaded
		case empty
	}
	var type: MockType
	init(_ type: MockType) {
		self.type = type
		switch type {
		case .loading:
			viewObjects = []
			loadingState = .loading
		case .loaded:
			viewObjects = [
				MockedRestaurant.TEST_RESTAURANT_VIEW_OBJECT_1,
				MockedRestaurant.TEST_RESTAURANT_VIEW_OBJECT_2
				
			]
			loadingState = .loaded
		case .empty:
			viewObjects = []
			loadingState = .loaded
		}
	}
	
	var viewObjects: Array<RestaurantViewObject>
	var loadingState: LoadingState
	var dataCount: Int {
		viewObjects.count
	}
	func fetchData() async throws {}
	func refresh() {}
}
