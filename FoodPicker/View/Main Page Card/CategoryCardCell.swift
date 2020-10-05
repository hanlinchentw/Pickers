//
//  CaptionCardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class CategoryCardCell : UICollectionViewCell {
    //MARK: - Properties
    var category : String? { didSet { configure()}}
    private let optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "new york")
        return iv
    }()
    private let seeMoreView: UIView = {
        let view = UIView()
        
        return view
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        
        addSubview(optionImageView)
        optionImageView.fit(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure(){
        guard let category = category else { return }
        optionImageView.image = UIImage(named: category)
    }
}

