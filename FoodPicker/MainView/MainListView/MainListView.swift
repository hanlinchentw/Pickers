//
//  MainListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import CoreData

enum LoadingState {
	case idle
	case loading
	case loaded
	case error
}

struct MainListView: View {
	@EnvironmentObject var coordinator: MainCoordinator
	@Environment(\.managedObjectContext) private var viewContext
	@StateObject var searchViewModel = SearchListViewModel()
	@StateObject var popularViewModel = MainListSectionViewModel(section: .popular)
	@StateObject var nearbyViewModel = MainListSectionViewModel(section: .nearby)
	
	var body: some View {
		ZStack {
			Color.listViewBackground.ignoresSafeArea()
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 24) {
					MainListSearchHeader(
						searchText: $searchViewModel.searchText,
						shouldMapButtonHide: $searchViewModel.isSearching,
						onEditing: searchViewModel.onEditing,
						onSubmit: searchViewModel.onSubmit,
						onClear: searchViewModel.onClear,
						mapButtonOnPress: { coordinator.presentMapView() }
					)

					if searchViewModel.isSearching {
						SearchListView(vm: searchViewModel)
							.environment(\.managedObjectContext, viewContext)
							.environmentObject(coordinator)
					} else {
						VStack {
							HorizontalSectionView(vm: popularViewModel)
								.environment(\.managedObjectContext, viewContext)
								.environmentObject(nearbyViewModel)
							VerticalSectionView(vm: nearbyViewModel)
								.environment(\.managedObjectContext, viewContext)
								.environmentObject(coordinator)
						}
					}
				}
			}
		}
		.onAppear {
			if popularViewModel.loadingState != .loaded { popularViewModel.fetchData() }
			if nearbyViewModel.loadingState != .loaded { nearbyViewModel.fetchData() }
		}
		.navigationBarHidden(true)
		.onTapToResign()
	}
}
