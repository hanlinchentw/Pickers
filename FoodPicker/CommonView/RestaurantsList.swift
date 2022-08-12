//
//  RestaurantsList.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/24.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let restaurantListCellIdentifier = "listCellIdentifier"
private let loadingCellIdentifier = "LoadCell"

protocol RestaurantsListDelegate: AnyObject {
//  func didSelectRestaurant(_ restaurant : Restaurant)
//  func didLikeRestaurant(_ restaurant : Restaurant)
//  func loadMoreData()
//  func didTapRestaurant(restaurant:Restaurant)
}

extension RestaurantsListDelegate{
//  func loadMoreData(){}
//  func didTapRestaurant(restaurant:Restaurant){}
//  func didLikeRestaurant(_ restaurant : Restaurant){}
}

class RestaurantsList: UITableView{
  //MARK: - Properties
  weak var listDelegate : RestaurantsListDelegate?
  var _restaurants = [RestaurantViewObject]()

//  var restaurants = [Restaurant]() { didSet { self.reloadData() }}
  var config: ListConfiguration? {
    didSet {
      self.reloadData()
      setScrollEnabled()
    }
  }
  var isScrolling: Bool = false
  //MARK: - Lifecycle
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: .plain)
    layer.cornerRadius = 16
    rowHeight = 93 + 24
    backgroundColor = .white
    separatorStyle = .none
    delegate = self
    dataSource = self

    register(RestaurantListCell.self, forCellReuseIdentifier: restaurantListCellIdentifier)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //MARK: - API
  func setScrollEnabled(){
    switch config {
    case .all, .edit:
      self.isScrollEnabled = true
    default:
      self.isScrollEnabled = false
    }
  }
}
extension RestaurantsList: UITableViewDelegate, UITableViewDataSource{
  func visibleCellsShouldRasterize(_ aBool:Bool){
    for cell in self.visibleCells as [UITableViewCell]{
      cell.layer.shouldRasterize = aBool;
    }
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
//    return restaurants.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.dequeueReusableCell(withIdentifier: restaurantListCellIdentifier, for: indexPath)
    as! RestaurantListCell
    cell.selectionStyle = .none
//    cell.delegate = self
//    let viewModel = CardCellViewModel(restaurant: self.restaurants[indexPath.row])
//    cell.viewModel = viewModel
    cell.config = self.config
    cell.contentView.isUserInteractionEnabled = true
    return cell
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 4
  }
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    isScrolling = false
    self.visibleCellsShouldRasterize(isScrolling)
  }

  func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    if velocity == CGPoint.zero{
      isScrolling = false
      self.visibleCellsShouldRasterize(isScrolling)
    }
  }
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    isScrolling = true
    self.visibleCellsShouldRasterize(isScrolling)

  }
  private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.layer.shouldRasterize = isScrolling
  }

  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    if config == .all, indexPath.section == 0{
      let likeAction = UIContextualAction(style: .normal, title: "Like") { [weak self] (action, view, completionHandler) in
        guard let _ = self else { return }
        print("Liked")
        completionHandler(true)
      }
      likeAction.backgroundColor = .butterscotch
      likeAction.image = UIImage(named: "icnHeartSmallW")?.withRenderingMode(.alwaysOriginal)
      let configuration = UISwipeActionsConfiguration(actions: [likeAction])
      configuration.performsFirstActionWithFullSwipe = true

      return configuration
    }
    return nil
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if config == .all, indexPath.section == 0{
//      listDelegate?.didTapRestaurant(restaurant: restaurants[indexPath.row])
    }
  }
}
//MARK: - UIScrollViewDelegate
extension RestaurantsList: UIScrollViewDelegate{
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    guard let isLoading = isLoading else { return }
    let threshold : CGFloat = 55
    let offsetY = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
//    if (maximumOffset - offsetY <= threshold) && !isLoading {
//    }
  }
}
//extension RestaurantsList: RestaurantListCellDelegate{
//  func didSelectRestaurant(_ restaurant: Restaurant) {
//    listDelegate?.didSelectRestaurant(restaurant)
//  }
//}
