//
//  LocationManager.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/9.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, LocationManagerProtocol {
	static let shared: LocationManager = {
		let instance = LocationManager()
		return instance
	}()
	
	var status: LocationManager.Status = .initiated
	

	var lastLocation: CLLocationCoordinate2D? {
		didSet {
			// Update the locationSubject with the new value of lastLocation
			locationSubject.send(lastLocation)
		}
	}
	
	// Create a CurrentValueSubject that publishes the current value of lastLocation
	private let locationSubject = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)

	// Create a computed property that returns the locationSubject as an AnyPublisher
	var locationPublisher: AnyPublisher<CLLocationCoordinate2D?, Never> {
		locationSubject.eraseToAnyPublisher()
	}
	
	private let locationManager = CLLocationManager()
	
	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		try? startTracking()
	}
	
	func requestAuthorization() {
		locationManager.requestWhenInUseAuthorization()
	}
	
	func startTracking() throws {
		switch authorizationStatus {
		case .notDetermined:
			status = .initiated
			requestAuthorization()
		case .authorizedAlways, .authorizedWhenInUse:
			locationManager.startUpdatingLocation()
			locationManager.startUpdatingHeading()
			status = .tracking
		case .restricted, .denied:
			status = .restricted
		@unknown default:
			stopTracking()
		}
	}
	
	func stopTracking() {
		guard status == Status.tracking else {
			return
		}
		locationManager.stopUpdatingLocation()
		locationManager.stopUpdatingHeading()
		status = .stopped
	}
	
	var authorizationStatus: CLAuthorizationStatus {
		locationManager.authorizationStatus
	}
}
