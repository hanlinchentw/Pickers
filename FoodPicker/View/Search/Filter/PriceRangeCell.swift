//
//  PriceRangeCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

enum PriceRange: Int{
    case oneSign
    case twoSign
    case threeSign
    case fourSign
    
    var description: String {
        switch self {
        case .oneSign: return "$"
        case .twoSign: return "$$"
        case .threeSign: return "$$$"
        case .fourSign: return "$$$$"
        }
    }
}

class PriceRangeCell: UICollectionViewCell {
    //MARK: - Proerties
    var priceRange: PriceRange? { didSet{ configure()}}
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        return label
    }()
    var isChosen: Bool = false  { didSet { configureCellStatus(isSelect: isChosen)}}
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        layer.cornerRadius = 72 / 2
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.7
        
        addSubview(priceLabel)
        priceLabel.center(inView: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configure(){
        priceLabel.text = priceRange?.description
    }
    
    func configureCellStatus(isSelect: Bool){
        let backgroudColor : UIColor = isSelect ? .black : .white
        let textColor : UIColor = !isSelect ? .black : .white
        self.backgroundColor = backgroudColor
        self.priceLabel.textColor = textColor
    }
}
