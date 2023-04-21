//
//  LocationManagerProtocol.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/19.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

protocol LocationManagerProtocol {
	var lastLocation: CLLocationCoordinate2D? { get set }
	var locationPublisher: AnyPublisher<CLLocationCoordinate2D?, Never> { get }
	var authorizationStatus: CLAuthorizationStatus { get }
	
	func startTracking() throws
	func stopTracking()
}
