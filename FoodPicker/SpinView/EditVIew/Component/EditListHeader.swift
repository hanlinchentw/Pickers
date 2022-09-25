//
//  EditListHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/17.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct EditListHeader: View {
	var leftButtonOnPress: () -> Void
	var rightButtonOnPress: () -> Void
	
	var body: some View {
		HStack {
			RoundedRectangle(cornerRadius: 22)
				.fill(Color.white)
				.overlay(Image("icnArrowBack"))
				.frame(width: 44, height: 44)
				.padding(.leading, 8)
				.onTapGesture {
					leftButtonOnPress()
				}
			Spacer()
			
			Button(action: rightButtonOnPress, label: {
				Image(systemName: "trash.fill")
					.frame(width: 44, height: 44)
					.foregroundColor(.red.opacity(0.5))
			})
			.padding(.trailing, 8)
			
		}
		.overlay(
			Text("Edit List").en16Bold()
		)
	}
}

struct EditListHeader_Previews: PreviewProvider {
	static var previews: some View {
		EditListHeader {
			
		} rightButtonOnPress: {
			
		}
		
	}
}
