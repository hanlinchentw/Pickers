//
//  FoodCardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let cardIdentifier = "CardCell"

protocol FoodCardCellDelegate: class {
    func didTappedRestaurant(_ restaurant: Restaurant)
    func didLikeRestaurant(_ restaurant: Restaurant)
}
class FilterResultSection : UICollectionViewCell {
    //MARK: - Properties
    weak var delegate : FoodCardCellDelegate?
    var restaurants = [Restaurant]() { didSet { collectionView.reloadData() } }
    var options : SortOption? {
        didSet {
            titleLabel.text = options?.description
            collectionView.reloadData()
        }
    }
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 24)
        return label
    }()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundColor
        return cv
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16,
                          paddingLeft: 24, height: 36)
        
        addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left:leftAnchor,right: rightAnchor, bottom: bottomAnchor,
                              paddingTop: 4, paddingLeft: 16)
        
        configureCollectionView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator  =  false
        collectionView.register(RestaurantCardCell.self, forCellWithReuseIdentifier: cardIdentifier)
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FilterResultSection : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardIdentifier, for: indexPath)
            as! RestaurantCardCell
        cell.restaurant = self.restaurants[indexPath.row]
        cell.delegate = self
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTappedRestaurant(restaurants[indexPath.row])
    }
}

extension FilterResultSection : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 240)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
extension FilterResultSection : CardCellDelegate {
    func didLikeRestaurant(_ restaurant: Restaurant) {
        for (index, res) in restaurants.enumerated() {
            if res.restaurantID == restaurant.restaurantID {
                self.restaurants[index].isLiked.toggle()
                break
            }
        }
        delegate?.didLikeRestaurant(restaurant)
    }
    func didSeletRestaurant(_ restaurant:Restaurant) {
        for (index, res) in restaurants.enumerated() {
            if res.restaurantID == restaurant.restaurantID {
                self.restaurants[index].isSelected = restaurant.isSelected
            }
        }
    }
}
