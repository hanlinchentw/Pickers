//
//  MapViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import GoogleMaps

final class MapViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
		let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
		self.view.addSubview(mapView)
		
		// Creates a marker in the center of the map.
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
		marker.title = "Sydney"
		marker.snippet = "Australia"
		marker.map = mapView
	}
}
