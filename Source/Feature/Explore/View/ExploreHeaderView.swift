//
//  ExploreHeaderView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import SwiftUI

struct ExploreHeaderView: View {
  var address: String?
	let location: CLLocationCoordinate2D

  @Binding var browseMode: BrowseMode
  @Binding var searchText: String

  var onClickFilterButton: () -> Void
	let onPressAddress: () -> Void

	var displayedLocation: String {
		guard let address else {
			return "\(location.latitude), \(location.longitude)"
		}
		return address
	}

  var body: some View {
    VStack {
			HStack {
				addressView(displayedLocation)
				Spacer()
				Button {
					withAnimation {
						browseMode = browseMode.toggle()
					}
				} label: {
					Image(browseMode == .map ? "search" : "map_color")
						.resizable()
						.scaledToFit()
						.frame(width: 28, height: 28)
						.tint(.butterScotch)
				}
				.buttonStyle(.plain)
			}
			.padding(.horizontal, 20)
      searchBar.padding(.horizontal, 16)
    }
  }

  var searchBar: some View {
    HStack {
      TextField("", text: $searchText)
        .placeholder(when: searchText.isEmpty) {
          HStack {
            Image(systemName: "magnifyingglass")
            Text("Search Picker")
              .semibold(size: 15)
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 12)
          .foregroundStyle(Color.gray6)
        }
        .background(Color.gray95)
        .height(48)
        .cornerRadius(24)
      Spacer()
      Button(
        action: {
          onClickFilterButton()
        }, label: {
          Image("filter")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18)
        }
      )
    }
  }

  @ViewBuilder
  func addressView(_ displayedLocation: String) -> some View {
		Button {
			onPressAddress()
		} label: {
			HStack {
				VStack(alignment: .leading, spacing: 6) {
					Text("Current At:")
						.semibold(size: 13)
					HStack {
						Text(displayedLocation)
							.bold(size: 15)
						Image(systemName: "chevron.down")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 12)
					}
				}
				Spacer()
			}
		}
		.buttonStyle(.plain)
  }
}

#Preview {
  ZStack {
    Color.clear
    ExploreHeaderView(
      address: "中山北路, 43 號",
			location: CLLocationCoordinate2D(latitude: 23.5, longitude: 121.5),
      browseMode: .constant(.list),
      searchText: .constant(String()),
      onClickFilterButton: {},
			onPressAddress: {}
    )
  }
}
