//
//  MapViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AlamofireImage

private let mapAnnotationIdentifier = "mapAnnotationIdentifier"
private let mapCardCellIdentifier = "mapCellIdentifier"


class MapViewController: UIViewController, MBProgressHUDProtocol{
    //MARK: - Properties
    public var restaurants = [Restaurant]() { didSet{
        self.addAnnotations(restaurants: self.restaurants)
    }
    }
    let bottomViewController = BottomSwipableCollectionViewController()
    private var mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    weak var delegate: MainPageChildControllersDelegate?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureCollectionView()
        guard let location = self.locationManager.location?.coordinate else { return }
        self.fetchRestaurant(location: location)
        self.startReceivingSingificantLocationChanges()
    }
    //MARK: - API
    fileprivate func fetchRestaurant(location: CLLocationCoordinate2D) {
        self.showLoadingAnimation()
        self.retry(3) { success, failure in
            self.fetchRestaurants(by: location, success: success, failure: failure)
        } success: {
            self.hideLoadingAnimation()
        } failure: { _ in
            self.hideLoadingAnimation()
        }
    }
    fileprivate func fetchRestaurants(by location: CLLocationCoordinate2D, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        self.fetchRestaurantsByOption(location: location) { (result, error) in
            if let result = result {
                self.restaurantsCheckProcess(restaurants: result) { checkedRestaurants in
                    self.restaurants += checkedRestaurants
                    self.bottomViewController.restaurants = self.restaurants
                }
                success()
            }else {
                if let error = error {
                    failure(error)
                }
            }
        }
    }
    func checkBeforeRestaurantLoaded(completion: (()->Void)?){
        for (index, item) in self.restaurants.enumerated(){
            let connect = CoredataConnect(context: context)
            connect.checkIfRestaurantIsIn(entity: selectedEntityName, id: item.restaurantID) { (isSelected) in
                guard isSelected else { return }
                self.restaurants[index].isSelected = true
            }
            connect.checkIfRestaurantIsIn(entity: likedEntityName, id: item.restaurantID) { (isLiked) in
                guard isLiked else { return }
                self.restaurants[index].isLiked = true
            }
        }
    }
    func updateSelectStatus(restaurantID: String){
        if let index = self.restaurants.firstIndex(where: { $0.restaurantID == restaurantID}) {
            self.restaurants[index].isSelected.toggle()
        }
    }
    func updateLikeRestaurant(restaurantID: String){
        if let index = self.restaurants.firstIndex(where: { $0.restaurantID == restaurantID}) {
            self.restaurants[index].isLiked.toggle()
        }
    }
    //MARK: - Helpers
    func checkIfUserAuthorize(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            configureMapView()
            startReceivingSingificantLocationChanges()
        default:
            configureNonAuthView()
        }
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
    func configureMapView(){
        mapView.frame = view.bounds
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 240+16, right: 0)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isZoomEnabled = true
    }
    func configureCollectionView(){
        addChild(bottomViewController)
        bottomViewController.delegate = self
        view.addSubview(bottomViewController.view)
        bottomViewController.view.anchor(left: view.leftAnchor,right: view.rightAnchor,
                             bottom: mapView.bottomAnchor,
                             paddingBottom: view.tabBarHeight, height: view.restaurantCardCGSize.height * 1.25)
    }
    func collectionViewAnimateOut() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.bottomViewController.view.transform = CGAffineTransform(translationX: 0, y: self.bottomViewController.view.frame.height)
        }
    }
    func collectionViewAnimateIn() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.bottomViewController.view.transform = .identity
        }
    }
    //MARK: - LocationManager Method
    func startReceivingSingificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            print("Service is not available")
            return
        }
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
    }
}
//MARK: - BottomSwipableCollectionViewControllerDelegate
extension MapViewController : BottomSwipableCollectionViewControllerDelegate{
    func didScrollToItem(restaurantID: String) {
        for anno in mapView.annotations {
            guard let anno = anno as? RestaurantAnnotation,
                  anno.id == restaurantID else { continue }
            mapView.selectAnnotation(anno, animated: true)
            break
        }
    }
    func didTapRestaurant(_ indexPath: IndexPath) {
        delegate?.pushToDetailVC(restaurants[indexPath.row])
    }
    func didLikeRestaurant(_ restaurant: Restaurant) {
        delegate?.didLikeRestaurant(restaurant: restaurant)
    }
    func didSelectRestaurant(_ restaurant: Restaurant) {
        delegate?.didSelectRestaurant(restaurant: restaurant)
    }
}
//MARK: -  Map Helpers
private extension MapViewController {
    func addAnnotations(restaurants : [Restaurant]){
        self.mapView.removeAnnotations(self.mapView.annotations)
        for (index, restaurant) in restaurants.enumerated() {
            let id = restaurant.restaurantID
            let anno = RestaurantAnnotation(id: id, url: restaurant.imageUrl)
            anno.coordinate = restaurant.coordinates
            anno.title = restaurant.name
            anno.index = index
            self.mapView.addAnnotation(anno)
        }
    }
}
//MARK: -  Map Delegate
extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("DEBUG: Did change location")
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
            self.mapView.setRegion(region, animated: true)
            self.fetchRestaurant(location: location.coordinate)
        }
    }
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.collectionViewAnimateOut()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let anno = view.annotation as? RestaurantAnnotation,
              let index = anno.index else { return }
        self.collectionViewAnimateIn()
        self.bottomViewController.scrollToSpecificRestaurant(at: index, withAnimation: false)
        let pinImage = UIImage(named: "btnLocationSelected")
        view.image = pinImage
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "btnLocationUnselect")
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? RestaurantAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: mapAnnotationIdentifier)
            view.image = UIImage(named: "btnLocationUnselect")
            view.contentMode = .scaleAspectFit
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 5)
            return view
        }else{ return nil }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let rendere = MKPolylineRenderer(overlay: overlay)
            rendere.lineWidth = 3
            rendere.strokeColor = .systemGreen
            return rendere
        }
}
