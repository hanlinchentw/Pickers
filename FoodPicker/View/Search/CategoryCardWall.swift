//
//  CategoryCardWall.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/10/9.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
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
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundColor
        cv.isScrollEnabled = false
        return cv
    }()
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
                              right: rightAnchor,  bottom: bottomAnchor, paddingTop: 4)
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoryCardWall: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryPreload.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCardIdentifier, for: indexPath) as! CategoryCardCell
        cell.category = categoryPreload[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CategoryCardWall: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 116, height: 80)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
