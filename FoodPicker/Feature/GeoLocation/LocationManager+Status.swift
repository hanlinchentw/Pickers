//
//  LocationManager+Status.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/10.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

extension LocationManager {
	enum Status {
		case initiated
		case tracking
		case stopped
		case restricted
	}
}
