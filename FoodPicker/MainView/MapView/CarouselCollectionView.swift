//
//  RestaurantCarouselCollectionView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/3.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

protocol CarouselViewDelegate: AnyObject {
  func itemTapSelectButton(restaurant: RestaurantViewObject)
  func itemTapLikeButton(restaurant: RestaurantViewObject)
  func didEndScrolling(restaurantId: String)
}

class CarouselCollectionView: UICollectionView {
  //MARK: - Properties
  var restaurants = [RestaurantViewObject]() {
    didSet {
      UIView.animate(withDuration: 0, animations: {
        self.reloadSections(.init([0]))
      })
    }
  }

  weak var carouselViewDelegate: CarouselViewDelegate?
  //MARK: - Lifecycle
  init() {
    let layout = ZoomAndSnapFlowLayout()
    layout.scrollDirection = .horizontal
    super.init(frame: .zero, collectionViewLayout: layout)
    dataSource = self
    delegate = self
    backgroundColor = .clear
    alwaysBounceHorizontal = true
    showsHorizontalScrollIndicator = false
    contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    register(RestaurantCardCell.self, forCellWithReuseIdentifier: NSStringFromClass(RestaurantCardCell.self))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension CarouselCollectionView: UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return restaurants.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(RestaurantCardCell.self), for: indexPath)
    as! RestaurantCardCell
    let restaurant = restaurants[indexPath.row]
    let actionButtonmode: ActionButtonMode = restaurant.isSelected ? .select : .deselect
    cell.presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonmode, isLiked: restaurant.isLiked)
    cell.delegate = self
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        self.cardDelegate?.pushToDetailVC(self.restaurants[indexPath.row])
  }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension CarouselCollectionView: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 280, height: 240)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 25
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    var visibleRect = CGRect()
    visibleRect.origin = self.contentOffset
    visibleRect.size = self.bounds.size
    let point = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    guard let indexPath = indexPathForItem(at: point) else { return }
    carouselViewDelegate?.didEndScrolling(restaurantId: restaurants[indexPath.row].id)
  }
}

extension CarouselCollectionView: RestaurantCardCellDelegate {
  func didTapSelectButton(restaurant: RestaurantViewObject) {
    carouselViewDelegate?.itemTapSelectButton(restaurant: restaurant)
  }

  func didTapLikeButton(restaurant: RestaurantViewObject) {
    carouselViewDelegate?.itemTapLikeButton(restaurant: restaurant)
  }
}
