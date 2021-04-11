//
//  FoodCardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let cardIdentifier = "CardCell"
private let footerIdentifier = "footerView"
protocol FilterResultSectionDelegate: class {
    func didTappedRestaurant(_ restaurant: Restaurant)
    func didLikeRestaurant(_ restaurant: Restaurant)
    func didSelectRestaurant(_ restaurant: Restaurant, option: recommendOption)
    func shouldShowMoreRestaurants(_ restaurants: [Restaurant])
}

enum recommendOption: CaseIterable {
    case topPick
    case popular
    
    var description: String {
        switch self {
        case .topPick: return "Top Picks"
        case .popular: return "Popular"
        }
    }
    var search: String {
        switch self {
        case .topPick: return "rating"
        case .popular: return "review_count"
        }
    }
}
class FilterResultSection: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate : FilterResultSectionDelegate?
    var restaurants = [Restaurant]() { didSet { collectionView.reloadData() } }
    var option : recommendOption? {
        didSet {
            titleLabel.text = option?.description
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
        collectionView.register(MoreRestaurantsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FilterResultSection : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardIdentifier, for: indexPath)
            as! RestaurantCardCell
        if !self.restaurants.isEmpty{
            cell.restaurant = self.restaurants[indexPath.row]
        }
        cell.delegate = self
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.restaurants.isEmpty{ delegate?.didTappedRestaurant(restaurants[indexPath.row]) }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! MoreRestaurantsFooterView
        footer.delegate = self
        return footer
    }
    
}

extension FilterResultSection : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 240)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 112, height: 240)
    }
}
extension FilterResultSection : RestaurantCardCellDelegate {
    func didLikeRestaurant(_ restaurant: Restaurant) {
        delegate?.didLikeRestaurant(restaurant)
    }
    func didSelectRestaurant(_ restaurant:Restaurant) {
        for (index, res) in restaurants.enumerated() {
            if res.restaurantID == restaurant.restaurantID {
                self.restaurants[index].isSelected = restaurant.isSelected
            }
        }
        guard let option = option else { return }
        delegate?.didSelectRestaurant(restaurant, option: option)
    }
}
extension FilterResultSection: MoreRestaurantsFooterViewDelegate{
    func shouldShowMoreRestaurants() {
        delegate?.shouldShowMoreRestaurants(self.restaurants)
    }
}
