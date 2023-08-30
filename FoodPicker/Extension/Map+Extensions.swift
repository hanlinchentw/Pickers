//
//  Map+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
  func fitAll() {
    var zoomRect  = MKMapRect.null;
    for annotation in annotations {
      let annotationPoint = MKMapPoint(annotation.coordinate)
      let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
      zoomRect = zoomRect.union(pointRect);
    }
    setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
  }

  static func openMapForPlace(name: String, coordinate: CLLocationCoordinate2D) {
    let regionDistance: CLLocationDistance = 3000
    let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    let options = [
      MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
      MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = name
    mapItem.openInMaps(launchOptions: options)
  }
}
