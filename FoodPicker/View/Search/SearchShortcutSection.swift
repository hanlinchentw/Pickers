//
//  SearchShortcutSection.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/20.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let keywordCardCellIdentifier = "keywordCard"


class SearchShortcutSection : UICollectionViewCell {
    //MARK: - Properties
    var keywords = [String]() { didSet{ self.collectionView.reloadData() }}
    
    var titleLabel : UILabel = {
        let label = UILabel()
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
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingLeft: 24)
        
        addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, right: rightAnchor,bottom: bottomAnchor,
                              paddingTop: 4)
        configureCollectionView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(KeywordCardCell.self, forCellWithReuseIdentifier: keywordCardCellIdentifier)
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchShortcutSection : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keywordCardCellIdentifier, for: indexPath) as! KeywordCardCell
        cell.keyword = keywords[indexPath.row]
        return cell
    }
}
extension SearchShortcutSection : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100, height: 32)
        return size
    }
}
class KeywordCardCell : UICollectionViewCell {
    //MARK: - Properties
    var keyword : String? { didSet{ keywordLabel.text = keyword}}
    private let keywordLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 14)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
   
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(keywordLabel)
        keywordLabel.fit(inView: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
