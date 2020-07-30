//
//  MainPageController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import MapKit


private let reuseIdentifier = "FoodCardCell"
private let annoIdentifier = "MapAnnoView"

struct FoodCardDataSoruce {
    var restaurants : [Restaurant]
    var option : FilterOptions
}
class MainPageController: UICollectionViewController {
    
    //MARK: - Properties
    private var mapView : MKMapView!
    private let navBarView = MainPageHeader()
    
    private let filterButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icnFilter")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
        return button
    }()
    private var filterView = FilterView()
    
    private var options = [FilterOptions]() {
        didSet {
            filterView.options = self.options
        }
    }
    private var mutableOption : FilterOptions? {
        didSet{
            guard let option = mutableOption else { return }
            if !options.contains(option){
                self.options.append(option)
                fetchRestaurants(option: option)
                return
            }else {
                self.options.remove(at: self.options.firstIndex(of: option)!)
                for (index, item) in dataSource.enumerated() {
                    if item.option == option{
                        self.dataSource.remove(at: index)
                        return
                    }
                }
            }
        }
    }
    private var restaurants : [Restaurant]? {
        didSet {
            guard let restaurants = restaurants else {return }
            guard let option = restaurants[0].filterOption else { return }
            let source = FoodCardDataSoruce(restaurants: restaurants, option: option)
            self.dataSource.append(source)
            addAnnotations(restaurants:restaurants)
            return
        }
    }
    private var dataSource = [FoodCardDataSoruce]() {
        didSet {
            self.collectionView.reloadData()
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.dataSource.forEach { (source) in
                let restaurants = source.restaurants
                self.addAnnotations(restaurants: restaurants)
            }
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
        configureUI()
        configureMapView()
        preloadRestaurants()
    }
    func preloadRestaurants(){
        let preload : [FilterOptions]  = [.nearby, .popular, .highestRate]
        for option in preload {
            self.mutableOption = option
        }
    }
    //MARK: - API
    func fetchRestaurants(withCategory category : String = "food", option: FilterOptions){
        guard let location = LocationHandler.shared.currentLocation else { return }
        let sortBy = option.sortby
        
        NetworkService.shared.fetchRestaurant(lat: location.latitude, lon: location.longitude,
                                              withOffset: 0,
                                              category: category,
                                              sortBy: sortBy,
                                              option: option)
        { (res) in
            self.restaurants = res
        }
    }
    //MARK: - Selectors
    @objc func handleFilter(){
        filterView.isHidden.toggle()
    }
    //MARK: - Helpers
    
    func configureNavBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navBarView.delegate = self
        view.addSubview(navBarView)
        navBarView.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          height: 104)
        
    }
    func configureCollectionView(){
        collectionView.contentInset = UIEdgeInsets(top: 152 - 44, left: 16, bottom: 0, right: 0)
        collectionView.backgroundColor = .backgroundColor
        collectionView.register(FoodCardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    func configureUI(){
        collectionView.addSubview(filterButton)
        filterButton.anchor(top:collectionView.topAnchor,right:view.rightAnchor,
                            paddingTop: -44, paddingRight: 16,
                            width: 48, height: 48)
        
        collectionView.addSubview(filterView)
        filterView.anchor(top:collectionView.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, paddingLeft: 8, paddingRight: 8,
                          height: 200)
        filterView.isHidden = true
        filterView.delegate = self
    }
    func configureMapView(){
        mapView = MKMapView(frame: view.bounds)
        
        view.insertSubview(mapView, at: 1)
        mapView.isHidden = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isZoomEnabled = true
    }
}
//MARK: -  UICollectionView Delegate/ DataSource
extension MainPageController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            as! FoodCardCell
        var feed = [Restaurant]()
        
        if indexPath.section == 1{
            let option = dataSource[indexPath.row].option
            feed = dataSource[indexPath.row].restaurants
            
            cell.options = option
            cell.restaurants = feed
            cell.cardSize = CGSize(width: 280, height: 240)
            cell.delegate = self
            cell.numofCell = feed.count
        }else{
            cell.options = nil
            cell.cardSize = CGSize(width: 136, height: 168)
            cell.numofCell = categoryPreload.count
        }
        return cell
    }
    
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MainPageController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return indexPath.section == 0 ?
            CGSize(width: view.frame.width, height: 168) : CGSize(width: view.frame.width, height: 280)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 24)
    }
    
}
//MARK: -  Map Helpers
private extension MainPageController {
    func addAnnotations(restaurants : [Restaurant]){
        restaurants.forEach { (restaurant) in
            let anno = MKPointAnnotation()
            anno.coordinate = restaurant.location
            anno.title = restaurant.name
            self.mapView.addAnnotation(anno)
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}
//MARK: - MainPageHeaderDelegate
extension MainPageController : MainPageHeaderDelegate {
    func handleHeaderGotTapped() {
        mapView.isHidden.toggle()
        filterView.isHidden.toggle()
    }
}
//MARK: - FoodCardCellDelegate
extension MainPageController : FoodCardCellDelegate {
    func didSelectCell(_ restaurant: Restaurant) {
        let detailVC = DetailController(restaurant: restaurant)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
//MARK: - FilterViewDelegate
extension MainPageController : FilterViewDelegate {
    func didSelectOption(_ filter: FilterOptions){
        self.mutableOption = filter
    }
}
