//
//  RestaurantCarouselCollectionView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/27.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

private let mapCardCellIdentifier = "mapCellIdentifier"

protocol RestaurantCarouselCollectionViewDelegate: RestaurantAPI{
    func didScrollToItem(restaurantID: String)
}

class RestaurantCarouselCollectionView: UICollectionView {
    //MARK: - Properties
    weak var cardDelegate: RestaurantCarouselCollectionViewDelegate?
    var restaurants = [RestaurantViewObject]() { didSet{ self.reloadData()} }
    //MARK: - Lifecycle
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        backgroundColor = .clear
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        register(RestaurantCardCell.self, forCellWithReuseIdentifier: mapCardCellIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension RestaurantCarouselCollectionView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapCardCellIdentifier, for: indexPath)
            as! RestaurantCardCell
//        cell.restaurant = self.restaurants[indexPath.row]
//        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.cardDelegate?.pushToDetailVC(self.restaurants[indexPath.row])
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension RestaurantCarouselCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height  = restaurantCardCGSize.height
        let width = restaurantCardCGSize.width
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let point = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = indexPathForItem(at: point) else { return }
//        cardDelegate?.didScrollToItem(restaurantID: self.restaurants[indexPath.row].restaurantID)
    }
}
//MARK: - CardCellDelegate
//extension RestaurantCarouselCollectionView : RestaurantAPI{
//    func didLikeRestaurant(restaurant: Restaurant) {
//        cardDelegate?.didLikeRestaurant(restaurant: restaurant)
//
//    }
//    func didSelectRestaurant(restaurant: Restaurant) {
//        print(restaurant.isSelected)
//        cardDelegate?.didSelectRestaurant(restaurant: restaurant)
//    }
//}
