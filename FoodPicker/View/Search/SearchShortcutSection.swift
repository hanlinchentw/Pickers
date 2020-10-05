//
//  SearchShortcutSection.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/20.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let keywordCardCellIdentifier = "keywordCard"
private let categoryCardIdentifier = "categoryCard"

class SearchShortcutSection : UICollectionViewCell {
    //MARK: - Properties
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
    var isKeywordSection: Bool!
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingLeft: 24)
        
        addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor,
                              right: rightAnchor,  bottom: bottomAnchor, paddingTop: 4)
        configureCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator  =  false
        collectionView.register(KeywordCardCell.self, forCellWithReuseIdentifier: keywordCardCellIdentifier)
        collectionView.register(CategoryCardCell.self, forCellWithReuseIdentifier: categoryCardIdentifier)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchShortcutSection : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isKeywordSection ? 3 : categoryPreload.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isKeywordSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keywordCardCellIdentifier, for: indexPath) as! KeywordCardCell
            if indexPath.row == 0 {
                
            }else {
                
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCardIdentifier, for: indexPath) as! CategoryCardCell
            cell.category = categoryPreload[indexPath.row]
            return cell
        }
    }
}

extension SearchShortcutSection : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = isKeywordSection ?  CGSize(width: 105, height: 32) : CGSize(width: 116, height: 80)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}



class KeywordCardCell : UICollectionViewCell {
    //MARK: - Properties
    private let keywordLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 14)
        label.text = "keyword"
        label.textAlignment = .center
        return label
    }()
   
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        layer.cornerRadius = 12
        
        addSubview(keywordLabel)
        keywordLabel.fit(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
