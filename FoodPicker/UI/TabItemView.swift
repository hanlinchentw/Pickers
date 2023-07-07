//
//  TabItemView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct TabItemView: View {
	
	var tab: TabItems
	var isActive: Bool
	var itemOnPress: () -> Void
	
	var body: some View {
		Button {
			itemOnPress()
		} label: {
			if isActive {
				Image(uiImage: tab.item.selectedImage ?? UIImage())
					.renderingMode(.original)
					.padding(.horizontal)
					.padding(.vertical, 4)
			} else {
				Image(uiImage: tab.item.image ?? UIImage())
					.renderingMode(.original)
					.padding(.horizontal)
					.padding(.vertical, 4)
			}
		}
	}
}

struct TabItemView_Previews: PreviewProvider {
	static var previews: some View {
		TabItemView(tab: .explore, isActive: true) {
			
		}
	}
}
