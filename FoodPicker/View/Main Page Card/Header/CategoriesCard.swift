//
//  SortHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/8/3.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol CategoryCardDelegate : AnyObject {
    func didTapCategoryCard(keyword: String)
}

private let captionIdentifier = "CaptionCardCell"

class CategoriesCard : UICollectionReusableView {
    //MARK: - Properties
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundColor
        return cv
    }()
    weak var delegate: CategoryCardDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                              bottom: bottomAnchor, paddingLeft: 16)
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
        collectionView.register(CategoryCardCell.self, forCellWithReuseIdentifier: captionIdentifier)
    }
}

extension CategoriesCard: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryPreload.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: captionIdentifier, for: indexPath)
        as! CategoryCardCell
        cell.category = categoryPreload[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryString = categoryPreload[indexPath.row]
        delegate?.didTapCategoryCard(keyword: categoryString)
    }
}

extension CategoriesCard: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 116, height: 80)
    }
}
