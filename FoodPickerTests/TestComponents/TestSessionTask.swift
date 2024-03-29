//
//  TestSessionTask.swift
//  FoodPickerTests
//
//  Created by 陳翰霖 on 2023/4/22.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import APIKit

class TestSessionTask: SessionTask {
	
	var handler: (Data?, URLResponse?, Error?) -> Void
	var cancelled = false
	
	init(handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		self.handler = handler
	}
	
	func resume() {
		
	}
	
	func cancel() {
		cancelled = true
	}
}
