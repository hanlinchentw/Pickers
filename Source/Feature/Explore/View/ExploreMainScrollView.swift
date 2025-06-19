//
//  ExploreMainScrollView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import SwiftUI

struct ExploreMainScrollView: View {
	let currentLocation: CLLocationCoordinate2D
	var viewModels: [PlaceViewModel]
	var isLoading: Bool
	var hasMoreToLoad: Bool
	var onClickHeart: (PlaceViewModel) -> Void
	var onClickSelect: (PlaceViewModel) -> Void
	var loadMoreIfNeeded: @Sendable () async -> Void
	var refresh: @Sendable () async -> Void
}

extension ExploreMainScrollView {
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .center) {
				ForEach(viewModels) { viewModel in
					ExploreItemView(
						viewModel: viewModel,
						distance: viewModel.distance(to: currentLocation),
						onClickHeart: {
							onClickHeart(viewModel)
						},
						onClickSelect: {
							onClickSelect(viewModel)
						}
					)
					.padding(.vertical)
				}
				if hasMoreToLoad {
					ProgressView("Loading Mode Good chooice...")
						.tint(.butterScotch)
						.padding(.vertical)
						.task { await loadMoreIfNeeded() }
				}
			}
			.padding(.horizontal)
		}
		.refreshable { await refresh() }
		.scrollIndicators(.hidden)
	}
}

#Preview {
	ExploreMainScrollView(
		currentLocation: .init(latitude: 23.5, longitude: 121),
		viewModels: [],
		isLoading: false,
		hasMoreToLoad: true,
		onClickHeart: {
			print($0)
		}, onClickSelect: {
			print($0)
		}, loadMoreIfNeeded: {
			print("Load more")
		}
	) {
	}
}
