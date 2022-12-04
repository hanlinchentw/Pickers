//
//  AppSettingHelper.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/24.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class AppSettingHelper {
	static func openSetting() {
		guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
			return
		}
		
		if UIApplication.shared.canOpenURL(settingsUrl) {
			UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
				print("Settings opened: \(success)") // Prints true
			})
		}
	}
}
