//
//  SearchBar.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class SearchBar : UICollectionReusableView {
    //MARK: - Properties
    private let searchBar : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 16
        tf.layer.masksToBounds = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 40))
        tf.leftViewMode = .always
        tf.placeholder = "Search"
        
        let iv = UIImageView()
        iv.image = UIImage(named: "icnSearchSmall")
        iv.contentMode = .scaleAspectFill
        tf.addSubview(iv)
        iv.centerY(inView:tf)
        iv.anchor(left:tf.leftAnchor,paddingLeft: 16,width: 24 ,height: 24)
        return tf
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        addSubview(searchBar)
        searchBar.anchor(top:topAnchor, left: leftAnchor,right: rightAnchor,
                         paddingLeft: 16,paddingRight: 16,width: 382, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
   
}
