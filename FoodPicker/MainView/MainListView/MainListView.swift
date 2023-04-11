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
	@StateObject var popularViewModel = MainListSectionViewModel(section: .popular)
	
	let pub = NotificationCenter.default.publisher(for: NSNotification.Name(Constants.firstTabGotTapped))
	
	var body: some View {
		ZStack {
			Color.listViewBackground.ignoresSafeArea()
			ScrollViewReader { proxy in
				ScrollView {
					VStack(spacing: 24) {
						VStack {
							HorizontalSectionView(vm: popularViewModel)
						}
						.onAppear {
							refreshList()
						}
					}
				}
				.refreshable {
					try? await popularViewModel.fetchData()
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
	}
}
