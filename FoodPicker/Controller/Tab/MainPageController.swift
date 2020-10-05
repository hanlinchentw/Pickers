//
//  MainPageController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import CoreData

private let foodCardSection = "FoodCardCell"
private let headerCell = "SortHeader"
private let footerCell = "AllRestaurantsSection"

struct SortedDataSource {
    var option : SortOption
    var restaurants : [Restaurant]
}
class MainPageController: UICollectionViewController {
    
    //MARK: - Properties
    private var mapView : MKMapView!
    private let locationManager = LocationHandler.shared.locationManager
    private let navBarView = MainPageNavigationBar()
    private var filterView = FilterView()
    private let actionSheetLauncher = ActionSheetLauncher()
    private var dataSource = [Restaurant]()
    
    private var recommendSectionDataSource = [SortedDataSource]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationHandler.shared.enableLocationServices()
        preloadAllRestaurants()
        preloadRecommendation()
        configureCollectionView()
        configureNavBar()
        configureFilterView()
        configureMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = true
    }
    private func preloadAllRestaurants(){
            self.fetchAllRestaurants(offset: 0, limit: 20)
    }
    private func preloadRecommendation(){
        let defaultOptions : [SortOption] = [.topPick, .popular]
        for option in defaultOptions {
            self.fetchRestaurantsByOption(option: option)
        }
    }
    //MARK: - API
    func fetchAllRestaurants(offset: Int, limit: Int){
        guard let location = locationManager.location?.coordinate else { return }
        NetworkService.shared
            .fetchRestaurants(lat: location.latitude, lon: location.longitude,
                                              withOffset: offset,
                                              limit: limit)
        { (restaurants) in
            guard let res = restaurants, !res.isEmpty else {
                print("DEBUG: Failed to get the restaurants..")
                return
            }
            print("DEBUG: Did fetch these restaurants...\(res[0].name)")
            self.dataSource += res
            self.addAnnotations(restaurants: res)
            self.collectionView.reloadData()
        }
    }
    func fetchRestaurantsByOption(option: SortOption){
        guard let location = locationManager.location?.coordinate else { return }
        
        NetworkService.shared
            .fetchRestaurants(lat: location.latitude, lon: location.longitude,
                            withOffset: 0, sortBy: option.sortby,
                            option: option, limit: 6)
            { (restaurants) in
                guard let res = restaurants, !res.isEmpty else {
                    print("DEBUG: Failed to get the restaurants..")
                    return
                }
                let result = SortedDataSource(option: option, restaurants: res)
                self.recommendSectionDataSource.append(result)
                self.collectionView.reloadData()
        }
    }
    func checkIfUserLiked(res: [Restaurant], completion: @escaping([Restaurant])->Void){
        var checkedRestaurants = [Restaurant]()
        for (index, item) in res.enumerated(){
            RestaurantService.shared.checkIfUserLikeRestaurant(restaurantID: item.restaurantID) { isLiked in
                var restaurant = item
                restaurant.isLiked = isLiked
                checkedRestaurants.append(restaurant)
            }
        }
        completion(checkedRestaurants)
    }
    
    func updateLikeRestaurant(restaurant: Restaurant){
        RestaurantService.shared.updateLikedRestaurant(restaurant: restaurant) { (err, ref) in
            if let err = err {
                print("DEBUG: Failed to update restaurant...\(err.localizedDescription)")
            }
        }
    }
    //MARK: - Helpers
    func configureNavBar(){
        navBarView.delegate = self
        view.addSubview(navBarView)
        navBarView.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          height: 104)
        
    }
    func configureFilterView(){
        filterView.delegate = self
        filterView.backgroundColor = .backgroundColor
        view.addSubview(filterView)
        filterView.anchor(top: navBarView.bottomAnchor, left: view.leftAnchor,
                          right: view.rightAnchor,
                          height: 72)
        actionSheetLauncher.delegate = self
        let backgroundView = UIView()
        backgroundView.backgroundColor = .backgroundColor
        view.insertSubview(backgroundView, aboveSubview: collectionView)
        backgroundView.fit(inView: navBarView)
    }
    func configureCollectionView(){
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            collectionView.contentInset = UIEdgeInsets(top: 104 - safeAreaHeight + 72,
                                                       left: 0, bottom: 16, right: 0)
        }else {
            collectionView.contentInset = UIEdgeInsets(top: 104 + 72,
                                                       left: 0, bottom: 16, right: 0)
        }
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.register(FilterResultSection.self, forCellWithReuseIdentifier: foodCardSection)
        collectionView.register(CategoriesCard.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCell)
        collectionView.register(AllRestaurantsSection.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerCell)
    }
    func configureMapView(){
        mapView = MKMapView(frame: view.bounds)
        locationManager.delegate = self
        view.insertSubview(mapView, at: 1)
        mapView.isHidden = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isZoomEnabled = true
    }
    //MARK: - Selectors
    @objc func handleRefresh(){
        collectionView.refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}
//MARK: -  UICollectionView Delegate/ DataSource
extension MainPageController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendSectionDataSource.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: foodCardSection, for: indexPath)
            as! FilterResultSection
        cell.options = recommendSectionDataSource[indexPath.row].option
        cell.restaurants = recommendSectionDataSource[indexPath.row].restaurants
        cell.delegate = self
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as! CategoriesCard
            return header
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCell, for: indexPath) as! AllRestaurantsSection
            footer.restaurants = dataSource
            footer.delegate = self
            return footer
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MainPageController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 304)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height : CGFloat = dataSource.isEmpty ?
            132 : 132 + 8 + CGFloat(104*dataSource.count)
        print("DEBUG: \(height) \(dataSource.count)")
        return CGSize(width: view.frame.width - 32 , height: height)
    }
}
//MARK: -  Map Helpers
private extension MainPageController {
    func addAnnotations(restaurants : [Restaurant]){
        restaurants.forEach { (restaurant) in
            let anno = MKPointAnnotation()
            anno.coordinate = restaurant.coordinates
            anno.title = restaurant.name
            self.mapView.addAnnotation(anno)
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}
//MARK: -  CLLocationManagerDelegate
extension MainPageController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0].coordinate
        print("DEBUG: Did update location ... ")
        let region = MKCoordinateRegion(center: location
            , latitudinalMeters: 5000, longitudinalMeters: 5000)
        self.mapView.setRegion(region, animated: true)
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
    func didLikeRestaurant(_ restaurant: Restaurant) {
        updateLikeRestaurant(restaurant: restaurant)
    }
    func didTappedRestaurant(_ restaurant: Restaurant) {
        let detailVC = DetailController(restaurant: restaurant)
        detailVC.fetchDetail()
        
        self.collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.pushViewController(detailVC, animated: true)
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}
//MARK: - AllRestaurantsSectionDelegate
extension MainPageController: AllRestaurantsSectionDelegate {
    func didSelectRestaurant(restaurant: Restaurant) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DID_SELECT_KEY),
        object: nil,
        userInfo: ["Restaurant": restaurant as Restaurant])
    }
    func didTapRestaurant(restaurant: Restaurant) {
        let detailVC = DetailController(restaurant: restaurant)
        detailVC.fetchDetail()
        self.collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.pushViewController(detailVC, animated: true)
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}
//MARK: - FilterViewDelegate
extension MainPageController : FilterViewDelegate {
    func didTapSortButton() {
        actionSheetLauncher.show(isSortButton: true)
    }
    
    func didTapPriceButton() {
        actionSheetLauncher.show(isSortButton: false)
    }
}
//MARK: -
extension MainPageController: ActionSheetLauncherDelegate {
    func didSelectSortOption(shouldAdd: Bool, option: SortOption) {
        print("DEBUG: Did select \(option.description)")
    
    }
}
