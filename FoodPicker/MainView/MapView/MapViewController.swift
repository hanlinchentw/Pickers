//
//  MapViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/3.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

import UIKit
import MapKit
import CoreLocation
import Combine
import Toast_Swift

class MapViewController: UIViewController {
  static let CAROUSEL_HEIGHT: CGFloat = 250
  //MARK: - Properties
  weak var coordinator: MainCoordinator?
  private let viewModel = MapViewModel()
  let carouselView = CarouselCollectionView()
  private var mapView = MKMapView()
  private var set = Set<AnyCancellable>()

  private let dismissButton: MapDismissButton = {
    let btn = MapDismissButton()
    btn.addTarget(self, action: #selector(dismissMapView), for: .touchUpInside)
    return btn
  }()

  private let locateButton: UIButton = {
    let btn = UIButton()
    btn.layer.cornerRadius = 26
    btn.setImage(UIImage(systemName: "location.fill.viewfinder"), for: .normal)
    btn.backgroundColor = .white
    btn.tintColor = .butterscotch
    btn.addTarget(self, action: #selector(relocateUser), for: .touchUpInside)
    return btn
  }()
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    bindRefreshing()
    bindUpdateAnnotation()
    Task { await viewModel.fetchRestaurant(latitude: viewModel.userLatitude, longitude: viewModel.userLongitude) }

    configureMapView()
    configureCollectionView()
    configureDismissButton()
    configureLocateButton()
  }
  // MARK: - Selector
  @objc func dismissMapView() {
    self.coordinator?.presentListView()
  }

  @objc func relocateUser() {
    let mapCenter = mapView.userLocation.coordinate
    let visibleRegion = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 1000, longitudinalMeters: 1000)
    mapView.setRegion(visibleRegion, animated: true)
  }
  // MARK: - Binding
  func bindRefreshing() {
    viewModel.$isRefresh
      .receive(on: DispatchQueue.main)
      .sink { _ in
        self.carouselView.restaurants = self.viewModel.restaurants
      }
      .store(in: &set)
  }

  func bindUpdateAnnotation() {
    viewModel.$updateAnnotation
      .receive(on: DispatchQueue.main)
      .sink { _ in
        self.addAnnotations(restaurants: self.viewModel.restaurants)
      }
      .store(in: &set)
  }
}
//MARK: -  Map Delegate
extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let centerCoordinate = mapView.centerCoordinate
    PresentHelper.showTapToast(
      on: self,
      withMessage: "Search this area",
      duration: .infinity,
      position: .top,
      makeStyle: { ToastStyle.searchThisArea })
    { didTap in
      if didTap {
        Task { await self.viewModel.fetchRestaurant(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)}
      }
    }
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let anno = view.annotation as? AnnotationItem,
          let index = anno.indexForCollectionView else { return }
    self.carouselView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: true)
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? AnnotationItem {
      let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(AnnotationItem.self))
      view.titleVisibility = .adaptive
      view.glyphText = "Me"
      view.markerTintColor = .butterscotch
      return view
    } else  { return nil }
  }

  @MainActor
  func makeVisibleRectFitAllAnnotations() {
    var zoomRect = MKMapRect.null;
    for annotation in self.mapView.annotations {
      if let _ = annotation as? MKUserLocation { continue }
      let annotationPoint = MKMapPoint(annotation.coordinate)
      let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
      zoomRect = zoomRect.union(pointRect)
    }
    self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
  }

  @MainActor
  func addAnnotations(restaurants : [RestaurantViewObject]){
    self.mapView.removeAnnotations(self.mapView.annotations)
    for (index, restaurant) in restaurants.enumerated() {
      let anno = AnnotationItem(restaurant: restaurant)
      anno.indexForCollectionView = index
      self.mapView.addAnnotation(anno)
    }
    self.makeVisibleRectFitAllAnnotations()
  }
}
// MARK: - CarouselViewDelegate
extension MapViewController: CarouselViewDelegate {
  func itemDidTap(restaurant: RestaurantViewObject) {
    coordinator?.pushToDetailView(id: restaurant.id)
  }

  func itemTapSelectButton(restaurant: RestaurantViewObject) {
		viewModel.selectRestaurant(isSelected: restaurant.isSelected, restaurant: restaurant)
    let indexPaths = carouselView.indexPathsForVisibleItems
    // 只有畫面中間那個物件可以操作：index 1
    self.carouselView.reloadItems(at: [indexPaths[1]])
  }

  func itemTapLikeButton(restaurant: RestaurantViewObject) {
		viewModel.likeRestaurant(isLiked: restaurant.isLiked, restaurant: restaurant)
    let indexPaths = carouselView.indexPathsForVisibleItems
    // 只有畫面中間那個物件可以操作：index 1
    self.carouselView.reloadItems(at: [indexPaths[1]])
  }

  func didEndScrolling(restaurantId: String) {
    for anno in mapView.annotations {
      guard let anno = anno as? AnnotationItem,
            anno.id == restaurantId else { continue }
      mapView.selectAnnotation(anno, animated: true)
      mapView.setRegion(MKCoordinateRegion(center: anno.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
      break
    }
  }
}
//MARK: - Auto layout
extension MapViewController {
  func configureDismissButton() {
    view.addSubview(dismissButton)
    dismissButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 15 + SafeAreaUtils.top, paddingRight: 8)
    dismissButton.setDimension(width: 44, height: 44)
    dismissButton.bindBadgeNumber(badgeNumber: viewModel.$numOfSelectRestaurant)
  }

  func configureLocateButton() {
    view.addSubview(locateButton)
    locateButton.anchor(top: dismissButton.bottomAnchor, right: view.rightAnchor, paddingTop: 24, paddingRight: 8)
    locateButton.setDimension(width: 52, height: 52)
  }

  func configureMapView() {
    mapView.frame = view.bounds
    view.addSubview(mapView)
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    mapView.mapType = .mutedStandard
    mapView.pointOfInterestFilter = .init(including: [.bakery, .bank, .cafe, .hospital, .police, .fireStation, .hospital, .restaurant])
    mapView.isZoomEnabled = true
    mapView.showsCompass = false
  }

  func configureCollectionView() {
    carouselView.carouselViewDelegate = self
    view.addSubview(carouselView)
    carouselView.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: mapView.bottomAnchor, paddingBottom: 50)
    carouselView.setDimension(width: view.frame.width, height: Self.CAROUSEL_HEIGHT)
  }

  func configureNonAuthView() {
    let titleLabel = UILabel()
    titleLabel.text = "Where are you?"
    titleLabel.textColor = .butterscotch
    titleLabel.font = UIFont(name: "Arial-BoldMT", size: 24)

    let contentLabel = UILabel()
    contentLabel.text = "Your location services need to be turned on in order for Maps to work."
    contentLabel.textColor = .black
    contentLabel.font = UIFont(name: "ArialMT", size: 16)
    contentLabel.numberOfLines = 0

    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "illustrationLocation")?.withRenderingMode(.alwaysOriginal)

    let stack = UIStackView(arrangedSubviews: [titleLabel, contentLabel, imageView])
    stack.spacing = 12
    stack.axis = .vertical
    stack.distribution = .fillProportionally

    view.addSubview(stack)
    stack.center(inView: view)
  }
}
