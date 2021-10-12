//
//  SortOptionCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

enum SortOption: Int, CaseIterable {
    case nearby
    case popular
    case rating
    
    var description : String {
        switch self {
        case .nearby: return "Nearby"
        case .popular: return "Popular"
        case .rating: return "Rating"
        }
    }
    var sortby : String {
        switch self {
        case .nearby: return "distance"
        case .popular: return "review_count"
        case .rating: return "rating"
        }
    }
}
class SortOptionCell: UICollectionViewCell {
    //MARK: - Properties
    var option : SortOption? { didSet{ configure()}}
    private let selectImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icnRadio")
        iv.setDimension(width: 48, height: 48)
        return iv
    }()
    
    private let optionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 16)
        label.textColor = .black
        return label
    }()
    override var isSelected: Bool {
        didSet {
            let image = isSelected ?
            UIImage(named: "icnRadioSelected") : UIImage(named: "icnRadio")
            selectImageView.image = image?.withRenderingMode(.alwaysOriginal)
        }
    }
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure(){
        optionLabel.text = option?.description
    }
    func configureUI(){
        let stack = UIStackView(arrangedSubviews: [selectImageView, optionLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 8
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
    }
}
