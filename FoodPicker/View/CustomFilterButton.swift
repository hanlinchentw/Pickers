//
//  CustomFilterButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/28.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class CustomFilterButton : UIView{
    
    //MARK: - Properties
    var text : String
    var option : FilterOptions
    var isSelected  = true { didSet { configure()}}
    
    var imageView  = UIImageView(image: UIImage(named: "icnOval"))
    //MARK: - Lifecycle
    init(option: FilterOptions) {
        self.option = option
        self.text = option.description
        super.init(frame: .zero)
        addSubview(imageView)
        imageView.anchor(top:topAnchor, left: leftAnchor, bottom: bottomAnchor)
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont(name: "Avenir-Book", size: 14)
        textLabel.textColor = .white
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, left: imageView.rightAnchor,right: rightAnchor, bottom: bottomAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configure(){
        if isSelected {
            imageView.image = UIImage(named: "icnOvalSelected")
        }else {
            imageView.image = UIImage(named: "icnOval")
        }
    }
}

