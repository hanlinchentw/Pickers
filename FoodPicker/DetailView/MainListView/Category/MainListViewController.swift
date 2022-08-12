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
import RxSwift
import RxCocoa

enum CategoryViewStatus {

}

private let foodCardSection = "FoodCardCell"
private let footerCell = "AllRestaurantsSection"

class MainListViewController: UICollectionViewController, MBProgressHUDProtocol {
  //MARK: - Properties
  weak var delegate: MainPageChildControllersDelegate?
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  var sections = Array<MainListSectionViewObject>()
  var allRestaurants: MainListSectionViewObject?

  private var viewModel: MainListViewModel!
  private let disposeBag = DisposeBag()
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = MainListViewModel()
    configureCollectionView()
    loadData()
  }
  func refreshData() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }

  func loadData() {
    viewModel
      .fetchPopularRestaurant()
      .subscribe(onSuccess: { [weak self] popularSection in
        self?.sections.append(popularSection)
        print("fetchPopularRestaurant.popularSection success")
        self?.refreshData()
      }, onFailure: { [weak self] error in
        print("fetchPopularRestaurant.popularSection failed error message: \(error.localizedDescription)")
        self?.hideLoadingAnimation()
      }).disposed(by: disposeBag)

    viewModel
      .fetchAllRestaurant()
      .subscribe(onSuccess: { [weak self] allSection in
        self?.allRestaurants = allSection
        print("fetchAllRestaurant.allSection success")
        self?.refreshData()
      }, onFailure: { [weak self] error in
        print("fetchAllRestaurant.allSection failed error message: \(error.localizedDescription)")
        self?.hideLoadingAnimation()
      }).disposed(by: disposeBag)
  }
}

//MARK: -  UICollectionView Delegate/ DataSource
extension MainListViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: foodCardSection, for: indexPath) as! MainListSectionView
//    cell.delegate = self
    if !sections.isEmpty { cell.sectionViewObject = sections[indexPath.row] }
    return cell
  }
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCell, for: indexPath) as! AllRestaurantsSectionView
    footer.restaurants = allRestaurants?.content ?? []
//    footer.delegate = self
    return footer
  }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MainListViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 281)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    let numOfAllRestaurants = allRestaurants?.content.count ?? 0
    let height : CGFloat = numOfAllRestaurants == 0 ? 132 : 132 + CGFloat(117 * numOfAllRestaurants)
    return CGSize(width: view.frame.width - 32 , height: height)
  }
}

//MARK: - FilterResultSectionDelegate
//extension MainListViewController : FilterResultSectionDelegate {
//  func didSelectRestaurant(_ restaurant: Restaurant) {
//    delegate?.didSelectRestaurant(restaurant: restaurant)
//  }
//  func didLikeRestaurant(restaurant: Restaurant) {
//    delegate?.didLikeRestaurant(restaurant: restaurant)
//  }
//  func pushToDetailVC(_ restaurant: Restaurant) {
//    self.delegate?.pushToDetailVC(restaurant)
//  }
//  func shouldShowMoreRestaurants(_ restaurants:[Restaurant]) {
//    let more = MoreRestaurantViewController(restaurants: restaurants, option: RestaurantSorting.popular)
//    more.delegate = self
//    self.parent?.navigationController?.pushViewController(more, animated: true)
//  }
//}
//MARK: - AllRestaurantsSectionDelegate
//extension MainListViewController: AllRestaurantsSectionDelegate {
//  func shouldSeeAllRestaurants(restaurants: [Restaurant]) {
//    let more = MoreRestaurantViewController(restaurants: restaurants, option: RestaurantSorting.all)
//    more.delegate = self
//    self.parent?.navigationController?.pushViewController(more, animated: true)
//  }
//  func didSelectRestaurant(restaurant: Restaurant){
//    delegate?.didSelectRestaurant(restaurant: restaurant)
//  }
//  func didTapRestaurant(restaurant: Restaurant) {
//    self.delegate?.pushToDetailVC(restaurant)
//  }
//}
//MARK: - MoreRestaurantViewControllerDelegate
//extension MainListViewController: MoreRestaurantViewControllerDelegate{
//  func willPopViewController(_ controller: MoreRestaurantViewController) {
//    controller.navigationController?.popViewController(animated: true)
//  }
//  func didSelectRestaurantFromMore(restaurant: Restaurant){
//    delegate?.didSelectRestaurant(restaurant: restaurant)
//  }
//  func didLikeRestaurantFromMore(restaurant: Restaurant) {
//    delegate?.didLikeRestaurant(restaurant: restaurant)
//  }
//}
//MARK: - Collection view set up
extension MainListViewController {
  func configureCollectionView(){
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.backgroundColor = .backgroundColor
    collectionView.register(MainListSectionView.self, forCellWithReuseIdentifier: foodCardSection)
    collectionView.register(AllRestaurantsSectionView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: footerCell)
  }
}
