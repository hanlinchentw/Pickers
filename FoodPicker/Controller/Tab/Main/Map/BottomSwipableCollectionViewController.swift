//
//  BottomCollectionViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/27.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

protocol BottomSwipableCollectionViewControllerDelegate: AnyObject {
    func didLikeRestaurant(_ restaurant: Restaurant)
    func didSelectRestaurant(_ restaurant: Restaurant)
    func didTapRestaurant(_ indexPath: IndexPath)
    func didScrollToItem(restaurantID: String)
}


class BottomSwipableCollectionViewController : UIViewController {
    //MARK: - Properties
    weak var delegate: BottomSwipableCollectionViewControllerDelegate?
    var restaurants = [Restaurant](){
        didSet{
            self.restaurantCardCollectionView.restaurants = self.restaurants
        }
    }
    lazy var restaurantCardCollectionView : RestaurantCarouselCollectionView = {
        let layout = ZoomAndSnapFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = RestaurantCarouselCollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    //MARK: - Helpers
    func configureCollectionView(){
        restaurantCardCollectionView.cardDelegate = self
        view.addSubview(restaurantCardCollectionView)
        restaurantCardCollectionView.anchor(top:view.topAnchor, left: view.leftAnchor,
                                            right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 4)
    }
    func scrollToSpecificRestaurant(at index: Int, withAnimation: Bool){
        self.restaurantCardCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: withAnimation)
    }
}
//MARK: - RestaurantCarouselCollectionViewDelegate
extension BottomSwipableCollectionViewController: RestaurantCarouselCollectionViewDelegate {
    func didScrollToItem(restaurantID: String) {
        delegate?.didScrollToItem(restaurantID: restaurantID)
    }
    func didLikeRestaurant(_ restaurant: Restaurant) {
        delegate?.didLikeRestaurant(restaurant)
    }
    
    func didSelectRestaurant(_ restaurant: Restaurant) {
        delegate?.didSelectRestaurant(restaurant)
    }
    
    func didTapCard(at indexPath: IndexPath) {
        delegate?.didTapRestaurant(indexPath)
    }
}
