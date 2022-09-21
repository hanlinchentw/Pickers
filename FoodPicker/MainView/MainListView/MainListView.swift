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
	@State var isSearching = false
	@StateObject var searchViewModel = SearchListViewModel()
	
	var body: some View {
		ZStack {
			Color.listViewBackground.ignoresSafeArea()
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 24) {
					MainListHeader(
						searchText: $searchViewModel.searchText,
						searchState: $searchViewModel.searchState
					)
					.environmentObject(coordinator)

					if isSearching {
						SearchListView(searchResult: $searchViewModel.searchResult)
					} else {
						sectionView
					}
				}
			}
		}
		.navigationBarHidden(true)
		.onTapToResign()
	}
	
	var sectionView: some View {
		ForEach(0 ..< MainListSection.allCases.count, id: \.self) { index in
			let section = MainListSection.init(rawValue: index)!
			if section != MainListSection.nearby {
				HorizontalSectionView(section: section)
				.environment(\.managedObjectContext, viewContext)
				.environmentObject(coordinator)
			} else {
				VerticalSectionView()
				.environment(\.managedObjectContext, viewContext)
				.environmentObject(coordinator)
			}
		}
	}
}
