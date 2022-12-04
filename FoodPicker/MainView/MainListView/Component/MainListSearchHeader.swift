//
//  SearchFieldContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/13.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct MainListSearchHeader: View {
	var onEditing:  ()  -> Void
	var mapButtonOnPress: () -> Void
	
	var body: some View {
		HStack(alignment: .center) {
			HStack {
				Image(systemName: "magnifyingglass")
					.frame(height: 44)
					.padding(.leading, 12)
				Text("Search for restaurants")
				Spacer()
			}
			.foregroundColor(.gray.opacity(0.5))
			.height(40)
			.roundedWithShadow(cornerRadius: 8)
			.padding(.trailing, 12)
			.onTapGesture {
				onEditing()
			}
			
			Button {
				mapButtonOnPress()
			} label: {
				Image(systemName: "map.circle.fill")
					.foregroundColor(.butterScotch)
					.frame(width: 40, height: 40)
			}
			.roundedWithShadow(cornerRadius: 8)
		}
		.padding(.top, 16)
		.padding(.leading, 16)
		.padding(.trailing, 12)
	}
}

struct SearchFieldContainer_Previews: PreviewProvider {
	static var previews: some View {
		
		MainListSearchHeader(
			onEditing: {},
			mapButtonOnPress: {}
		)
	}
}
