//
//  PriceRangeCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit


class PriceRangeCell: UICollectionViewCell {
    //MARK: - Proerties
    var numOfPrice: Int? { didSet{ configure()}}
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        layer.cornerRadius = 72 / 2
        layer.borderColor = UIColor.backgroundColor.cgColor
        layer.borderWidth = 0.7
        
        addSubview(priceLabel)
        priceLabel.center(inView: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configure(){
        guard let num = numOfPrice else { return }
        let price = String(repeating: "$", count: num)
    
        priceLabel.text = price
    }
}
