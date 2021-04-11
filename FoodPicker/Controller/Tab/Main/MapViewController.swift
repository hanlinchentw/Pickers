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
private let mapAnnotationIdentifier = "mapAnnotationIdentifier"
private let mapCardCellIdentifier = "mapCellIdentifier"

protocol MapViewControllerDelegate: CategoriesViewControllerDelegate{}

class MapViewController: UIViewController{
    //MARK: - Properties
    public var restaurants = [Restaurant]() { didSet{
            self.addAnnotations(restaurants: self.restaurants)
            self.collecionView.reloadData()
        }
    }
    lazy var collecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var mapView : MKMapView!
    private let locationManager = LocationHandler.shared.locationManager
    weak var delegate: MapViewControllerDelegate?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureCollectionView()
    }
    //MARK: - API
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
    //MARK: - Helpers
    func configureCollectionView(){
        collecionView.delegate = self
        collecionView.dataSource = self
        collecionView.showsHorizontalScrollIndicator = false
        collecionView.register(RestaurantCardCell.self, forCellWithReuseIdentifier: mapCardCellIdentifier)
        
        view.addSubview(collecionView)
        collecionView.anchor(left: view.leftAnchor,right: view.rightAnchor,
                             bottom: mapView.bottomAnchor,
                             paddingLeft: 16,paddingBottom: 88+16, height: 240)
    }
    func checkIfUserAuthorize(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            configureMapView()
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
        mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 240+16, right: 0)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isZoomEnabled = true
        
        guard let location = self.locationManager.location?.coordinate else { return}
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1200, longitudinalMeters: 1200)
        self.mapView.setRegion(region, animated: true)
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecionView.dequeueReusableCell(withReuseIdentifier: mapCardCellIdentifier, for: indexPath)
        as! RestaurantCardCell
        cell.restaurant = self.restaurants[indexPath.row]
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.pushToDetailVC(restaurants[indexPath.row])
    }
}
extension MapViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 240)
    }
}
//MARK: - CardCellDelegate
extension MapViewController : RestaurantCardCellDelegate{
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
            let anno = RestaurantAnnotation(id: id)
            
            anno.coordinate = restaurant.coordinates
            anno.title = restaurant.name
            anno.index = index
            self.mapView.addAnnotation(anno)
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}
//MARK: -  Map Delegate
extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let anno = view.annotation as? RestaurantAnnotation,
              let index = anno.index else { return }
        view.image = #imageLiteral(resourceName: "btnLocationSelected").withRenderingMode(.alwaysOriginal)
        self.collecionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                        at: .centeredHorizontally, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? RestaurantAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: mapAnnotationIdentifier)
            view.image = #imageLiteral(resourceName: "btnLocationUnselect").withRenderingMode(.alwaysOriginal)
            view.contentMode = .scaleAspectFit
            view.canShowCallout = true
            return view
        }else{
            return nil
        }
    }
}
