//
//  MapViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import GoogleMaps
import Combine

final class MapViewController: UIViewController {
	lazy var mapView: GMSMapView = {
		let mapView = GMSMapView(frame: .zero)
		mapView.isMyLocationEnabled = true
		return mapView
	}()
	
	let viewModel: ExploreViewModel
	
	private var set = Set<AnyCancellable>()
	
	init(viewModel: ExploreViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		setupMapView()
//		bindViewObjectsChanged()
	}
}

extension MapViewController {
	func setupMapView() {
		mapView.delegate = self
		view.addSubview(mapView)
		mapView.fit(inView: view)
	}
	
	func bindViewObjectsChanged() {
		viewModel.viewObjectsPublisher
			.receive(on: RunLoop.main)
			.sink { viewObjects in
				viewObjects
					.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
					.map { GMSMarker(position: $0) }
					.forEach { $0.map = self.mapView }
			}
			.store(in: &set)
	}
}

extension MapViewController {
	func isMarkerWithinScreen(marker: GMSMarker, _ mapView: GMSMapView) -> Bool {
		let region = self.mapView.projection.visibleRegion()
		let bounds = GMSCoordinateBounds(region: region)
		return bounds.contains(marker.position)
	}
}

extension MapViewController: GMSMapViewDelegate {
	func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
		if !isMarkerWithinScreen(marker: marker, mapView) {
				let camera = GMSCameraPosition(target: marker.position, zoom: mapView.camera.zoom)
				self.mapView.animate(to: camera)
		}
	}
}
