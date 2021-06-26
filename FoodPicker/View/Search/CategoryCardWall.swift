//
//  CategoryCardWall.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/10/9.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol CategoryCardWallDelegate: AnyObject {
    func searchRestaurantByTappingCard(_ keyword: String)
}



private let categoryCardIdentifier = "categoryCard"

class CategoryCardWall: UICollectionReusableView{
    //MARK: - Properites
    var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Top Categories"
        label.font = UIFont(name: "Arial-BoldMT", size: 14)
        return label
    }()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundColor
        cv.isScrollEnabled = false
        return cv
    }()
    
    weak var delegate: CategoryCardWallDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
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
        collectionView.register(CategoryCardCell.self, forCellWithReuseIdentifier: categoryCardIdentifier)
    }
    func configureUI(){
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 24,paddingLeft: 24)
        
        addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor,
                              right: rightAnchor,  bottom: bottomAnchor,
                              paddingTop: 4, paddingLeft: -8,paddingRight: 8)
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoryCardWall: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryPreload.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCardIdentifier, for: indexPath)
            as! CategoryCardCell
        cell.category = categoryPreload[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keyword = categoryPreload[indexPath.row]
        delegate?.searchRestaurantByTappingCard(keyword)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CategoryCardWall: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return categoryCardCGSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing = CGFloat(screenWidth - categoryCardCGSize.width*3 - 24)/2
        return spacing
    }
}
