//
//  TabBarView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/3/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
	@Binding var tabSelected: HomeTabItem

	var body: some View {
		VStack {
			Spacer()
			HStack(spacing: 36) {
				Spacer()
				ForEach(HomeTabItem.allCases, id: \.self) { value in
					BarButton(selected: $tabSelected, value: value)
					Spacer(minLength: 0)
				}
			}
			.frame(height: 104)
			.background(Color.white)
			.cornerRadius(36)
		}
		.ignoresSafeArea()
	}
}

struct TabBarView_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			Color.gray.ignoresSafeArea()
			TabBarView(tabSelected: .constant(.Recommend))
		}
	}
}

struct BarButton : View {
	@Binding var selected : HomeTabItem
	
	var value: HomeTabItem
	
	var image: Image {
		selected == value ? value.selectedImage : value.unselectedImage
	}
	
	var body: some View{
		Button(action: {
			withAnimation(.spring()){
				selected = value
			}
		}, label: {
			image
				.resizable()
				.renderingMode(.original)
				.frame(width: value.iconSize, height: value.iconSize)
		})
	}
}
