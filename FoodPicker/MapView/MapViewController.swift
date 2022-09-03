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

class MapViewController: UIViewController {
  //MARK: - Properties
  private let viewModel = MapViewModel()
  let carouselView = CarouselCollectionView()
  private var mapView = MKMapView()
  private var set = Set<AnyCancellable>()
  private let dismissButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 12
    button.backgroundColor = .white
    button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
    button.addTarget(self, action: #selector(dismissMapView), for: .touchUpInside)
    button.tintColor = .butterscotch
    return button
  }()
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureMapView()
    configureCollectionView()
    configureDismissButton()
    fetchRestaurantNearBy()
    bindRefreshing()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionViewAnimateIn(delay: 0)
  }

  @objc func dismissMapView() {
    OperationQueue.main.addOperation {
      self.dismiss(animated: true)
    }
  }
  //MARK: - Data fetching
  func fetchRestaurantNearBy() {
    Task {
      MBProgressHUDHelper.showLoadingAnimation()
      await viewModel.fetchRestaurantNearby()
      MBProgressHUDHelper.hideLoadingAnimation()
    }
  }
  // MARK: - Binding
  func bindRefreshing() {
    viewModel.$isRefresh.combineLatest(viewModel.$restaurants)
      .filter({ _, restaurants in
        !restaurants.isEmpty
      })
      .sink { _ in
        OperationQueue.main.addOperation {
          self.addAnnotations(restaurants: self.viewModel.restaurants)
          self.carouselView.restaurants = self.viewModel.restaurants
        }
      }
      .store(in: &set)
  }
}
//MARK: - BottomSwipableCollectionViewControllerDelegate
extension MapViewController {
  func didScrollToItem(restaurantID: String) {
    for anno in mapView.annotations {
      guard let anno = anno as? AnnotationItem,
            anno.id == restaurantID else { continue }
      mapView.selectAnnotation(anno, animated: true)
      break
    }
  }
}
//MARK: -  Map Helpers
extension MapViewController {
  func addAnnotations(restaurants : [RestaurantViewObject]){
    self.mapView.removeAnnotations(self.mapView.annotations)
    for (index, restaurant) in restaurants.enumerated() {
      let anno = AnnotationItem(restaurant: restaurant)
      anno.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
      anno.title = restaurant.name
      anno.indexForCollectionView = index
      self.mapView.addAnnotation(anno)
    }
    self.makeVisibleRectFitAllAnnotations()
  }
}
//MARK: -  Map Delegate
@MainActor
extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    self.collectionViewAnimateOut(delay: 0.5)
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let anno = view.annotation as? AnnotationItem,
          let index = anno.indexForCollectionView else { return }
    self.collectionViewAnimateIn(delay: 0)
    self.carouselView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: true)
    view.image = UIImage(named: "btnLocationSelected")
  }

  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    view.image = UIImage(named: "btnLocationUnselect")
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? AnnotationItem {
      let view = MKAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(AnnotationItem.self))
      view.image = UIImage(named: "btnLocationUnselect")
      view.contentMode = .scaleAspectFit
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: 0, y: 5)
      return view
    }else{ return nil }
  }

  @MainActor
  func makeVisibleRectFitAllAnnotations() {
    var zoomRect = MKMapRect.null;
    for annotation in self.mapView.annotations {
      let annotationPoint = MKMapPoint(annotation.coordinate)
      let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
      zoomRect = zoomRect.union(pointRect)
    }
    self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
  }
}
// MARK: -
extension MapViewController: CarouselViewDelegate {
  func itemTapSelectButton(restaurant: RestaurantViewObject) {
    viewModel.didTapSelectButton(restaurant)
  }

  func itemTapLikeButton(restaurant: RestaurantViewObject) {

  }

  func didEndScrolling(endAt indexPath: IndexPath) {
    let restaurant = viewModel.restaurants[indexPath.row]
    guard let annotations = mapView.annotations as? Array<AnnotationItem>,
          let annotation = annotations.first(where: { $0.id == restaurant.id }) else {
      return
    }
    mapView.selectAnnotation(annotation, animated: true)
  }
}
// MARK: - Bottom Collection View Animation
extension MapViewController {
  @MainActor
  func collectionViewAnimateOut(delay: CGFloat) {
    UIView.animate(withDuration: 0.7, delay: delay, options: .curveEaseInOut) {
      self.carouselView.transform = .identity
    }
  }

  @MainActor
  func collectionViewAnimateIn(delay: CGFloat) {
    UIView.animate(withDuration: 0.7, delay: delay, options: .curveEaseInOut) {
      self.carouselView.transform = .init(translationX: 0, y: -350)
    }
  }
}
//MARK: - Auto layout
extension MapViewController {
  func configureDismissButton() {
    view.addSubview(dismissButton)
    dismissButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 32, paddingRight: 16)
    dismissButton.setDimension(width: 44, height: 44)
  }

  func configureMapView(){
    mapView.frame = view.bounds
    view.addSubview(mapView)
    mapView.delegate = self
    mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 240 + 16, right: 0)
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    mapView.isZoomEnabled = true
  }

  func configureCollectionView(){
    carouselView.carouselViewDelegate = self
    view.addSubview(carouselView)
    carouselView.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
    carouselView.setDimension(width: view.frame.width, height: 300)
  }

  func configureNonAuthView(){
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
