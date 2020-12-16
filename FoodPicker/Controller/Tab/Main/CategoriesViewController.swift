//
//  CategoriesViewController.swift
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

protocol CategoriesViewControllerDelegate: class {
    func pushToDetailVC(_ restaurant: Restaurant)
    func didLikeRestaurant(_ restaurant: Restaurant)
}
class CategoriesViewController: UICollectionViewController {
    //MARK: - Properties
    private let locationManager = LocationHandler.shared.locationManager
    weak var delegate: CategoriesViewControllerDelegate?
    
    let defaultOptions : [recommendOption] = [.popular, .topPick]
    var dataSource = [Restaurant]() { didSet{ self.collectionView.reloadData()}}
    var topPicksDataSource = [Restaurant]()  { didSet{ self.collectionView.reloadData()}}
    var popularDataSource = [Restaurant]()  { didSet{ self.collectionView.reloadData()}}
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    func updateLikeRestaurant(restaurant: Restaurant, shouldLike:Bool){
        RestaurantService.shared.updateLikedRestaurant(restaurant: restaurant, shouldLike: shouldLike)
    }
    //MARK: - Helpers
    func configureCollectionView(){
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.register(FilterResultSection.self, forCellWithReuseIdentifier: foodCardSection)
        collectionView.register(CategoriesCard.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCell)
        collectionView.register(AllRestaurantsSection.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerCell)
    }
    public func updateSelectStauts(restaurant: Restaurant){
        if let index = self.popularDataSource.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }) {
            self.popularDataSource[index].isSelected.toggle()
        }
        if let index = self.topPicksDataSource.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }){
            self.topPicksDataSource[index].isSelected.toggle()
        }
        if let index = self.dataSource.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }){
            self.dataSource[index].isSelected.toggle()
        }
    }
    public func deselectAll(){
        for index in 0...self.popularDataSource.count-1{ self.popularDataSource[index].isSelected = false }
        for index in 0...self.topPicksDataSource.count-1{ self.topPicksDataSource[index].isSelected = false }
        for index in 0...self.dataSource.count-1{ self.dataSource[index].isSelected = false }
    }
}
//MARK: -  UICollectionView Delegate/ DataSource
extension CategoriesViewController {
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
extension CategoriesViewController : UICollectionViewDelegateFlowLayout {
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
//MARK: - FilterResultSectionDelegate
extension CategoriesViewController : FilterResultSectionDelegate {
    func didSelectRestaurant(_ restaurant: Restaurant, option: recommendOption) {
        updateSelectStauts(restaurant: restaurant)
        let tab = self.tabBarController as? HomeController
        tab?.updateSelectedRestaurants(from: self, restaurant: restaurant)
    }
    func didLikeRestaurant(_ restaurant: Restaurant) {
        delegate?.didLikeRestaurant(restaurant)
    }
    func didTappedRestaurant(_ restaurant: Restaurant) {
        self.delegate?.pushToDetailVC(restaurant)
    }
    func shouldShowMoreRestaurants(_ restaurants:[Restaurant]) {
        let more = MoreRestaurantViewController(restaurants: restaurants)
        more.delegate = self
        self.parent?.navigationController?.pushViewController(more, animated: true)
    }
}
//MARK: - AllRestaurantsSectionDelegate
extension CategoriesViewController: AllRestaurantsSectionDelegate {
    func shouldSeeAllRestaurants(restaurants: [Restaurant]) {
        let more = MoreRestaurantViewController(restaurants: restaurants)
        more.delegate = self
        self.parent?.navigationController?.pushViewController(more, animated: true)
    }
    func didSelectRestaurant(restaurant: Restaurant){
        print("DEBUG: Did select restaurant ... ")
        updateSelectStauts(restaurant: restaurant)
        let tab = self.tabBarController as? HomeController
        tab?.updateSelectedRestaurants(from: self, restaurant: restaurant)
        self.collectionView.reloadData()
    }
    func didTapRestaurant(restaurant: Restaurant) {
        self.delegate?.pushToDetailVC(restaurant)
    }
}
//MARK: - ListViewControllerDelegate
extension CategoriesViewController: ListViewControllerDelegate{
    func willPopViewController(_ controller: MoreRestaurantViewController) {
        for restaurant in controller.selectedRestaurants {
            updateSelectStauts(restaurant: restaurant)
            let tab = self.tabBarController as? HomeController
            tab?.updateSelectedRestaurants(from: self, restaurant: restaurant)
        }
        controller.navigationController?.popViewController(animated: true)
    }
}

