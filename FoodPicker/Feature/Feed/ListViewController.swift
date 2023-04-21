//
//  ListViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import APIKit

final class ListViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let request = NearbySearchRequest(keyword: "food", latitude: 23.12, longitude: 125.1)
		
		Session.send(request) { result in
			switch result {
			case .success(let sueccess):
				print("success >>> \(sueccess)")
			case .failure(let failure):
				print("success >>> \(failure)")
			}
		}
	}
}
