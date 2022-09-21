//
//  SearchListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct SearchListView: View {
	@Binding var searchResult: Array<RestaurantViewObject>

	var body: some View {
		ZStack {
			Color.listViewBackground
			
		}
		.ignoresSafeArea()
	}
}

struct SearchListView_Previews: PreviewProvider {
	static var previews: some View {
		SearchListView(searchResult: .constant(MockedRestaurant.TEST_RESTAURANT_VIEW_OBJECT_ARRAY))
	}
}
