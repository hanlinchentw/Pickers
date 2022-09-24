//
//  SearchFieldContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct MainListSearchHeader: View {
	@Binding var searchText: String
	var mapButtonOnPress: () -> Void
	
	var body: some View {
		HStack(alignment: .center) {
			TextField("", text: $searchText)
			.placeholder(when: searchText.isEmpty) {
				HStack {
					Image(systemName: "magnifyingglass")
					Text("Search for restaurants")
				}
				.foregroundColor(.gray.opacity(0.5))
			}
			.showClearButton(text: $searchText)
			.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
			.height(40)
			.roundedWithShadow(cornerRadius: 8)

			Button {
				mapButtonOnPress()
			} label: {
				Image(systemName: "map.circle.fill")
					.foregroundColor(.butterScotch)
					.frame(width: searchText.isEmpty ? 40 : 0, height: searchText.isEmpty ? 40 : 0)
			}
			.roundedWithShadow(cornerRadius: 8)
			.opacity(searchText.isEmpty ? 1 : 0)
			.animation(.easeInOut(duration: 0.2), value: searchText.isEmpty)
		}
		.padding(.top, 16)
		.padding(.leading, 16)
		.padding(.trailing, 12)
	}
}

struct SearchFieldContainer_Previews: PreviewProvider {
	static var previews: some View {
		
		MainListSearchHeader(
			searchText: .constant(""),
			mapButtonOnPress: {
			
			}
		)
	}
}
