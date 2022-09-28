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
							} else if popularViewModel.loadingState == .error && nearbyViewModel.loadingState == .error {
								emptyView
							} else {
								HorizontalSectionView(vm: popularViewModel)
								VerticalSectionView(vm: nearbyViewModel)
							}
						}
						.onAppear {
							refreshList()
						}
					} else {
						LocationNotFoundView().padding(.top, 50)
					}
				}
			}
			.if(!searchViewModel.showSearchResult) {
				$0.refreshable {
				 try? await popularViewModel.fetchData()
				 try? await nearbyViewModel.fetchData()
			 }
			}
		}
		.navigationBarHidden(true)
		.onTapToResign()
	}
	
	var emptyView: some View {
		Button {
			refreshList()
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
	
	func refreshList() {
		popularViewModel.refresh()
		nearbyViewModel.refresh()
	}
}
