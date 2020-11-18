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

private let foodCardSection = "FoodCardCell"
private let headerCell = "SortHeader"
private let footerCell = "AllRestaurantsSection"

class MainPageController: UICollectionViewController {
    //MARK: - Properties
    private let navBarView = MainPageNavigationBar()
    private let locationManager = LocationHandler.shared.locationManager
    private let mapVC = MapViewController()
    
    private var dataSource = [Restaurant]() { didSet{ self.collectionView.reloadData()}}
    let defaultOptions : [recommendOption] = [.popular, .topPick]
    private var topPicksDataSource = [Restaurant]()  { didSet{ self.collectionView.reloadData()}}
    private var popularDataSource = [Restaurant]()  { didSet{ self.collectionView.reloadData()}}
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationHandler.shared.enableLocationServices()
        preloadData()
        configureCollectionView()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = true
    }
    func preloadData(){
        for option in defaultOptions {
            self.fetchRestaurantsByOption(option: option, limit: 6) { result in
                self.restaurantCheckProcess(restaurants: result) { (checkedRestaurants) in
                    if option == .topPick {
                        self.topPicksDataSource = checkedRestaurants
                        return
                    }else if option == .popular{
                        self.popularDataSource = checkedRestaurants
                        return
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.fetchRestaurantsByOption(limit: 20) { (restaurants) in
                self.dataSource = restaurants
                self.mapVC.restaurants = restaurants
            }
        }
    }
    func restaurantCheckProcess(restaurants: [Restaurant], completion: @escaping([Restaurant])->Void) {
        var uncheckedRestaurants = restaurants
        for (index, item) in uncheckedRestaurants.enumerated(){
            self.checkIfUserLiked(uncheckedRestaurant: item) { (isLiked) in
                uncheckedRestaurants[index].isLiked = isLiked
                completion(uncheckedRestaurants)
            }
        }
    }
    //MARK: - API
    func fetchRestaurantsByOption(option: recommendOption? = nil, limit: Int, completion: @escaping([Restaurant])-> Void) {
        guard let location = locationManager.location?.coordinate else { return  }
        NetworkService.shared
            .fetchRestaurants(lat: location.latitude, lon: location.longitude, option: option, limit: limit)
            { (restaurants) in
                guard let res = restaurants, !res.isEmpty else {
                    print("DEBUG: Failed to get the restaurants ...")
                    return
                }
                print("DEBUG: Loading data ...")
                completion(res)
                
        }
    }
    func checkIfUserLiked(uncheckedRestaurant: Restaurant, completion: @escaping(Bool)->Void){
        RestaurantService.shared
            .checkIfUserLikeRestaurant(restaurantID: uncheckedRestaurant.restaurantID)
            { isLiked in
                completion(isLiked)
        }
    }
    func updateLikeRestaurant(restaurant: Restaurant, shouldLike:Bool){
        RestaurantService.shared.updateLikedRestaurant(restaurant: restaurant, shouldLike: shouldLike)
    }
    //MARK: - Helpers
    func configureUI(){
        navBarView.delegate = self
        view.addSubview(navBarView)
        navBarView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 104)
        guard let map = mapVC.view else { return }
        view.insertSubview(map, at: 1)
        map.isHidden = true
    }
    func configureCollectionView(){
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            collectionView.contentInset = UIEdgeInsets(top: 104 - safeAreaHeight + 32,
                                                       left: 0, bottom: 16, right: 0)
        }else {
            collectionView.contentInset = UIEdgeInsets(top: 104 + 32,
                                                       left: 0, bottom: 16, right: 0)
        }
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .backgroundColor
        
        collectionView.register(FilterResultSection.self, forCellWithReuseIdentifier: foodCardSection)
        collectionView.register(CategoriesCard.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCell)
        collectionView.register(AllRestaurantsSection.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerCell)
    }
    fileprivate func pushToDetailVC(_ restaurant: Restaurant) {
        let detailVC = DetailController(restaurant: restaurant)
        detailVC.fetchDetail()
        detailVC.delegate = self
        self.collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.pushViewController(detailVC, animated: true)
            self.collectionView.isUserInteractionEnabled = true
        }
    }
    private func updateSelectStauts(restaurant: Restaurant, isSelectd: Bool){
        if let index = self.popularDataSource.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }) {
            self.popularDataSource[index].isSelected.toggle()
        }
        if let index = self.topPicksDataSource.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }){
            self.topPicksDataSource[index].isSelected.toggle()
        }
        if let index = self.dataSource.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }){
            self.dataSource[index].isSelected.toggle()
        }
        let tab = self.tabBarController as? HomeController
        tab?.didSelect(restaurant: restaurant)
    }
    //MARK: - Selectors
    @objc func handleRefresh(){
        collectionView.refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.preloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}
//MARK: -  UICollectionView Delegate/ DataSource
extension MainPageController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultOptions.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: foodCardSection, for: indexPath)
            as! FilterResultSection
        
        let source = indexPath.row == 0 ? popularDataSource : topPicksDataSource
        cell.restaurants = source
        cell.option = defaultOptions[indexPath.row]
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
        let height : CGFloat = dataSource.isEmpty ? 132 : 132 + CGFloat(117*dataSource.count)
        return CGSize(width: view.frame.width - 32 , height: height)
    }
}
//MARK: - MainPageHeaderDelegate
extension MainPageController : MainPageHeaderDelegate {
    func handleHeaderGotTapped() {
        mapVC.view.isHidden.toggle()
    }
}
//MARK: - FilterResultSectionDelegate
extension MainPageController : FilterResultSectionDelegate {
    func didSelectRestaurant(_ restaurant: Restaurant, option: recommendOption) {
        updateSelectStauts(restaurant: restaurant, isSelectd: restaurant.isSelected)
    }
    func didLikeRestaurant(_ restaurant: Restaurant) {
        updateLikeRestaurant(restaurant: restaurant, shouldLike: !restaurant.isLiked)
    }
    func didTappedRestaurant(_ restaurant: Restaurant) {
        pushToDetailVC(restaurant)
    }
    func shouldShowMoreRestaurants(_ restaurants:[Restaurant]) {
        let list = ListViewController(restaurants: restaurants)
        list.delegate = self
        self.navigationController?.pushViewController(list, animated: true)
    }
}
//MARK: - AllRestaurantsSectionDelegate
extension MainPageController: AllRestaurantsSectionDelegate {
    func shouldSeeAllRestaurants(restaurants: [Restaurant]) {
        let list = ListViewController(restaurants: restaurants)
        list.delegate = self
        self.navigationController?.pushViewController(list, animated: true)
    }
    func didSelectRestaurant(restaurant: Restaurant) {
        updateSelectStauts(restaurant: restaurant, isSelectd: restaurant.isSelected)
        self.collectionView.reloadData()
    }
    func didTapRestaurant(restaurant: Restaurant) {
        self.pushToDetailVC(restaurant)
    }
}
//MARK: - ListViewControllerDelegate
extension MainPageController: ListViewControllerDelegate{
    func willPopViewController(_ controller: ListViewController) {
        for restaurant in controller.selectedRestaurants {
            updateSelectStauts(restaurant: restaurant, isSelectd: restaurant.isSelected)
        }
        controller.navigationController?.popViewController(animated: true)
    }
}
extension MainPageController: DetailControllerDelegate {
    func willPopViewController(_ controller: DetailController) {
        let restaurant = controller.restaurant
        updateLikeRestaurant(restaurant: restaurant, shouldLike: restaurant.isLiked)
        controller.navigationController?.popViewController(animated: true)
    }
}
