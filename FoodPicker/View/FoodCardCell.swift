//
//  FoodCardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let cardIdentifier = "CardCell"
private let captionIdentifier = "CaptionCardCell"

protocol FoodCardCellDelegate: class {
    func didSelectCell(_ restaurant: Restaurant)
}
class FoodCardCell : UICollectionViewCell {
    //MARK: - Properties
    weak var delegate : FoodCardCellDelegate?
    var restaurants = [Restaurant]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var options : FilterOptions? {
        didSet {
            titleLabel.text = options?.description ?? ""
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
    
    var cardSize : CGSize!
    var numofCell : Int!
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        
        addSubview(collectionView)
        collectionView.anchor(top:topAnchor,left:leftAnchor,right: rightAnchor, bottom: bottomAnchor)
        
        collectionView.addSubview(titleLabel)
        titleLabel.anchor(top:collectionView.topAnchor, left: leftAnchor,
                          paddingLeft: 8, height: 36)
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
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: cardIdentifier)
        collectionView.register(CaptionCardCell.self, forCellWithReuseIdentifier: captionIdentifier)
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FoodCardCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numofCell
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if options != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardIdentifier, for: indexPath)
                as! CardCell
            cell.restaurant = self.restaurants[indexPath.row]
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: captionIdentifier, for: indexPath)
            as! CaptionCardCell
        cell.category = categoryPreload[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCell(restaurants[indexPath.row])
    }
}

extension FoodCardCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if options == nil {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
extension FoodCardCell : CardCellDelegate {
    func didLikeRestaurant(_ restaurant: Restaurant) {
        for (index, res) in restaurants.enumerated() {
            if res.restaurantID == restaurant.restaurantID {
                self.restaurants[index].isLiked = restaurant.isLiked
            }
        }
    }
    
    func didSeletRestaurant(_ restaurant:Restaurant) {
        for (index, res) in restaurants.enumerated() {
            if res.restaurantID == restaurant.restaurantID {
                self.restaurants[index].isSelected = restaurant.isSelected
            }
        }
    }
}
