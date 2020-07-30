//
//  CaptionCardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/6.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class CaptionCardCell : UICollectionViewCell {
    //MARK: - Properties
    var category : String? { didSet { configure()}}
    private let optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "new york")
        return iv
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.text = "New York"
        label.textAlignment = .center
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        
        addSubview(optionImageView)
        optionImageView.anchor(top:topAnchor, left: leftAnchor, right: rightAnchor,bottom: bottomAnchor,
                               paddingTop: 8, paddingLeft:8, paddingRight: 8,paddingBottom: 40)
        
        addSubview(captionLabel)
        captionLabel.anchor(top:optionImageView.bottomAnchor, left: leftAnchor,right: rightAnchor,bottom: bottomAnchor,
                            paddingTop: 8,paddingLeft: 8, paddingRight: 8, paddingBottom: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure(){
        guard let category = category else { return }
        captionLabel.text = category
        optionImageView.image = UIImage(named: category)
    }
}

