//
//  StaticJsonFileReader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/22.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

final class StaticJsonFileReader: NSObject {
	static func read(_ filename: String) -> Data? {
		if let path = Bundle.main.path(forResource: filename, ofType: "json"),
			 let staticData = FileManager.default.contents(atPath: path) {
			return staticData
		}
		return nil
	}
}
