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
	@Inject var locationService: LocationService
	@EnvironmentObject var coordinator: MainCoordinator
	@Environment(\.managedObjectContext) private var viewContext
	@StateObject var popularViewModel = MainListSectionViewModel(section: .popular)
	@StateObject var nearbyViewModel = MainListSectionViewModel(section: .nearby)
	
	let pub = NotificationCenter.default.publisher(for: NSNotification.Name(Constants.firstTabGotTapped))
	
	var body: some View {
		ZStack {
			Color.listViewBackground.ignoresSafeArea()
			ScrollViewReader { proxy in
				ScrollView {
					VStack(spacing: 24) {
						MainListSearchHeader(
							onEditing: {
								coordinator.presentSearchViewController()
							},
							mapButtonOnPress: { coordinator.presentMapView() }
						)
						.id("MainListSearchHeader")
						
						if locationService.lastLocation != nil {
							VStack {
								if popularViewModel.loadingState == .error && nearbyViewModel.loadingState == .error {
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
				.refreshable {
					try? await popularViewModel.fetchData()
					try? await nearbyViewModel.fetchData()
				}
				.onReceive(pub, perform: { _ in
					withAnimation(.easeInOut(duration: 1)) {
						proxy.scrollTo("MainListSearchHeader")
					}
				})
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
