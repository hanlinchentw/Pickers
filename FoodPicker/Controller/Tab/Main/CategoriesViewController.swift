//
//  CategoriesViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//
import UIKit
import CoreLocation
import Firebase
import CoreData
import Combine

private let foodCardSection = "FoodCardCell"
private let headerCell = "SortHeader"
private let footerCell = "AllRestaurantsSection"

protocol CategoriesViewControllerDelegate: AnyObject {
    func pushToDetailVC(_ restaurant: Restaurant)
    func didSelectRestaurant(restaurant:Restaurant)
    func didLikeRestaurant(restaurant:Restaurant)
    func didTapCategoryCard(textOnCard text: String)
}

class CategoriesViewController: UICollectionViewController, MBProgressHUDProtocol {
    //MARK: - Properties
    private let locationManager = LocationHandler.shared.locationManager
    weak var delegate: CategoriesViewControllerDelegate?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaultOptions : [recommendOption] = [.popular, .topPick]
    var dataSource = [Restaurant]() { didSet{ self.collectionView.reloadData()}}
    var topPicksDataSource = [Restaurant]()  { didSet{ self.collectionView.reloadData()}}
    var popularDataSource = [Restaurant]()  { didSet{ self.collectionView.reloadData()}}
    
    private var subscriber = Set<AnyCancellable>()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        deselectAll()
    }
   
    //MARK: - Helpers
    func configureCollectionView(){
        collectionView.isSkeletonable = true
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.register(FilterResultSection.self, forCellWithReuseIdentifier: foodCardSection)
        collectionView.register(CategoriesCard.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCell)
        collectionView.register(AllRestaurantsSection.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerCell)
    }
    func updateSelectStatus(restaurantID: String){
        if let index = self.popularDataSource.firstIndex(where: { $0.restaurantID == restaurantID}) {
            self.popularDataSource[index].isSelected.toggle()
        }
        if let index = self.topPicksDataSource.firstIndex(where: { $0.restaurantID == restaurantID}){
            self.topPicksDataSource[index].isSelected.toggle()
        }
        if let index = self.dataSource.firstIndex(where: { $0.restaurantID == restaurantID}){
            self.dataSource[index].isSelected.toggle()
        }
    }
    func updateLikeRestaurant(restaurantID: String){
        if let index = self.popularDataSource.firstIndex(where: { $0.restaurantID == restaurantID}) {
            self.popularDataSource[index].isLiked.toggle()
        }
        if let index = self.topPicksDataSource.firstIndex(where: { $0.restaurantID == restaurantID}){
            self.topPicksDataSource[index].isLiked.toggle()
        }
        if let index = self.dataSource.firstIndex(where: { $0.restaurantID == restaurantID}){
            self.dataSource[index].isLiked.toggle()
        }
    }
    
    //MARK: - Core data
    public func deselectAll(){
        let connect = CoredataConnect(context: context)
        connect.deleteAllRestaurant(in: selectedEntityName)
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
            header.delegate = self
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
        let height : CGFloat = dataSource.isEmpty ? 132 : 132 + CGFloat(117*dataSource.count)
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
    func didSelectRestaurant(_ restaurant: Restaurant, option: recommendOption) {
        delegate?.didSelectRestaurant(restaurant: restaurant)
    }
    func didLikeRestaurant(_ restaurant: Restaurant) {
        delegate?.didLikeRestaurant(restaurant: restaurant)
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
