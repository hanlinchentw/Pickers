//
//  CategoriesViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//
import UIKit
import CoreLocation
import CoreData

private let foodCardSection = "FoodCardCell"
private let headerCell = "SortHeader"
private let footerCell = "AllRestaurantsSection"

class CategoriesViewController: UICollectionViewController, MBProgressHUDProtocol {
    //MARK: - Properties
    weak var delegate: MainPageChildControllersDelegate?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var defaultOptions : Set<recommendOption> = [.popular, .topPick] { didSet{ self.collectionView.reloadData() }}
    var dataSource = RestaurantsFiltered(restaurants: [], filterOption: .all)
    var topPicksDataSource = RestaurantsFiltered(restaurants: [], filterOption: .topPick)
    var popularDataSource = RestaurantsFiltered(restaurants: [], filterOption: .popular)
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
}
//MARK: - Update collectionview data source
extension CategoriesViewController {
    func updateSelectStatus(restaurantID: String, shouldSelect: Bool){
        guard let delegate = delegate else { return }
        self.popularDataSource.restaurants =
            delegate.updateRestaurantSelectStatus(restaurants: &popularDataSource.restaurants, restaurantID: restaurantID, shouldSelect: shouldSelect)
        
        self.topPicksDataSource.restaurants =
            delegate.updateRestaurantSelectStatus(restaurants: &topPicksDataSource.restaurants, restaurantID: restaurantID, shouldSelect: shouldSelect)
    
        self.dataSource.restaurants =
            delegate.updateRestaurantSelectStatus(restaurants: &dataSource.restaurants, restaurantID: restaurantID, shouldSelect: shouldSelect)
        
        self.collectionView.reloadData()
    }
    func updateLikeRestaurant(restaurantID: String, shouldLike: Bool){
        guard let delegate = delegate else { return }
        self.popularDataSource.restaurants =
            delegate.updateRestaurantLikeStatus(restaurants: &popularDataSource.restaurants, restaurantID: restaurantID, shouldLike: shouldLike)
        
        self.topPicksDataSource.restaurants =
            delegate.updateRestaurantLikeStatus(restaurants: &topPicksDataSource.restaurants, restaurantID: restaurantID, shouldLike: shouldLike)
        
        self.dataSource.restaurants =
            delegate.updateRestaurantLikeStatus(restaurants: &dataSource.restaurants, restaurantID: restaurantID, shouldLike: shouldLike)
        self.collectionView.reloadData()
    }
    func calculatTheSectionNumber(){
        if self.popularDataSource.restaurants.isEmpty { self.defaultOptions.remove(.popular) }
        else { self.defaultOptions.insert(.popular)}
        if self.topPicksDataSource.restaurants.isEmpty { self.defaultOptions.remove(.topPick) }
        else { self.defaultOptions.insert(.topPick)}
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
        cell.restaurants = source.restaurants
        cell.option = indexPath.row == 0 ? .popular : .topPick
        cell.delegate = self
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as! CategoriesCard
            header.delegate = self
            return header
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCell, for: indexPath) as! AllRestaurantsSection
            footer.restaurants = dataSource.restaurants
            footer.delegate = self
            return footer
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 304 * view.heightMultiplier * view.iPhoneSEMutiplier
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height : CGFloat = dataSource.restaurants.isEmpty ? 132 : 132 + CGFloat(117*dataSource.restaurants.count)
        return CGSize(width: view.frame.width - 32 , height: height)
    }
}

//MARK: - CategoryCardDelegate
extension CategoriesViewController: CategoryCardDelegate {
    func didTapCategoryCard(keyword: String) {
        delegate?.didTapCategoryCard(textOnCard: keyword)
    }
}
//MARK: - FilterResultSectionDelegate
extension CategoriesViewController : FilterResultSectionDelegate {
    func didSelectRestaurant(_ restaurant: Restaurant) {
        delegate?.didSelectRestaurant(restaurant: restaurant)
    }
    func didLikeRestaurant(restaurant: Restaurant) {
        delegate?.didLikeRestaurant(restaurant: restaurant)
    }
    func pushToDetailVC(_ restaurant: Restaurant) {
        self.delegate?.pushToDetailVC(restaurant)
    }
    func shouldShowMoreRestaurants(_ restaurants:[Restaurant]) {
        let more = MoreRestaurantViewController(restaurants: restaurants,
                                                option: restaurants[0].category ?? .popular)
        more.delegate = self
        self.parent?.navigationController?.pushViewController(more, animated: true)
    }
}
//MARK: - AllRestaurantsSectionDelegate
extension CategoriesViewController: AllRestaurantsSectionDelegate {
    func shouldSeeAllRestaurants(restaurants: [Restaurant]) {
        let more = MoreRestaurantViewController(restaurants: restaurants, option: recommendOption.all)
        more.delegate = self
        self.parent?.navigationController?.pushViewController(more, animated: true)
    }
    func didSelectRestaurant(restaurant: Restaurant){
        delegate?.didSelectRestaurant(restaurant: restaurant)
    }
    func didTapRestaurant(restaurant: Restaurant) {
        self.delegate?.pushToDetailVC(restaurant)
    }
}
//MARK: - MoreRestaurantViewControllerDelegate
extension CategoriesViewController: MoreRestaurantViewControllerDelegate{
    func willPopViewController(_ controller: MoreRestaurantViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    func didSelectRestaurantFromMore(restaurant: Restaurant){
        delegate?.didSelectRestaurant(restaurant: restaurant)
    }
    func didLikeRestaurantFromMore(restaurant: Restaurant) {
        delegate?.didLikeRestaurant(restaurant: restaurant)
    }
}
//MARK: - Collection view set up
extension CategoriesViewController {
    func configureCollectionView(){
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.register(FilterResultSection.self, forCellWithReuseIdentifier: foodCardSection)
        collectionView.register(CategoriesCard.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCell)
        collectionView.register(AllRestaurantsSection.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerCell)
    }
}
