//
//  HomeTabContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/3/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct HomeTabContainer: View {
	@State var tabSelected: HomeTabItem = .Recommend
	
	private var selectionTab: Binding<Int> {
		Binding {
			tabSelected.rawValue
		} set: {
			tabSelected = HomeTabItem(rawValue: $0)!
		}
	}

	var body: some View {
		ZStack {
			TabView(selection: selectionTab) {
				MainListView()
					.tag(HomeTabItem.Recommend.rawValue)
				LotteryContainer()
					.tag(HomeTabItem.Lottery.rawValue)
				FavoriteView()
					.tag(HomeTabItem.Favorite.rawValue)
			}

			TabBarView(tabSelected: $tabSelected)
		}
	}
}

struct HomeTabContainer_Previews: PreviewProvider {
	static var previews: some View {
		HomeTabContainer()
	}
}
