//
//  LocationNotFoundView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/24.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI

struct LocationNotFoundView: View {
	var body: some View {
		VStack(alignment: .center) {
			Text("Where are you?")
				.en24Bold()
				.foregroundColor(.butterScotch)
			Text("Come on. Let me know where you are 🥺")
				.en16()
				.foregroundColor(.black.opacity(0.8))
				.multilineTextAlignment(.center)
				.padding(.top, 8)
				.padding(.horizontal, 24)
			Image("illustrationLocation")
				.frame(width: 336, height: 223)
				.padding(.top, 24)
			Button {
				AppSettingHelper.openSetting()
			} label: {
				Text("Go Setting").en16().foregroundColor(.white)
					.frame(width: 336, height: 48)
			}
			.background(Color.butterScotch)
			.cornerRadius(12)
		}
	}
}

struct LocationNotFoundView_Previews: PreviewProvider {
	static var previews: some View {
		LocationNotFoundView()
	}
}
