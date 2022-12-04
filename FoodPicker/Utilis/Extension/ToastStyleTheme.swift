//
//  ToastStyleTheme.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Toast_Swift

extension ToastStyle {
	static var capsuleButterText: ToastStyle {
		var style = ToastStyle()
		style.cornerRadius = 18
		style.horizontalPadding = 16
		style.messageAlignment = .center
		return style
	}

	static var whiteCapsuleButterText: ToastStyle {
		var style = capsuleButterText
		style.messageColor = .butterscotch
		style.backgroundColor = .white
		return style
	}
	
	static var blackCapsuleButterText: ToastStyle {
		var style = capsuleButterText
		style.backgroundColor = .black
		style.messageColor = .white
		return style
	}
}
