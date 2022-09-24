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
	@ObservedObject var locationService: LocationService
	@EnvironmentObject var coordinator: MainCoordinator
	@Environment(\.managedObjectContext) private var viewContext
	@StateObject var searchViewModel = SearchListViewModel()
	@StateObject var popularViewModel = MainListSectionViewModel(section: .popular)
	@StateObject var nearbyViewModel = MainListSectionViewModel(section: .nearby)
	
	var body: some View {
		ZStack {
			Color.listViewBackground.ignoresSafeArea()
			ScrollView {
				VStack(spacing: 24) {
					MainListSearchHeader(
						searchText: $searchViewModel.searchText,
						mapButtonOnPress: { coordinator.presentMapView() }
					)

					if locationService.lastLocation != nil {
						VStack {
							if searchViewModel.showSearchResult {
								SearchListView(vm: searchViewModel)
							} else {
								HorizontalSectionView(vm: popularViewModel)
								VerticalSectionView(vm: nearbyViewModel)
							}
						}
						.onAppear {
							popularViewModel.refresh()
							nearbyViewModel.refresh()
						}
					} else {
						LocationNotFoundView().padding(.top, 50)
					}
				}
			}
			.refreshable {
				try? await popularViewModel.fetchData()
				try? await nearbyViewModel.fetchData()
			}
		}
		.navigationBarHidden(true)
		.onTapToResign()
	}
}
