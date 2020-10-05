//
//  SortOptionCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

enum SortOption: Int, CaseIterable {
    case topPick
    case popular
    case rating
    case numOfFavortie
    
    
    var description : String {
        switch self {
        case .topPick: return "Top Pick"
        case .popular: return "Popular"
        case .rating: return "Rating"
        case .numOfFavortie: return "Numbers of Favorite"
        
        }
    }
    var sortby : String {
        switch self {
        case .topPick: return "rating"
        case .popular: return "review_count"
        case .rating: return ""
        case .numOfFavortie: return ""
        }
    }
}
class SortOptionCell: UITableViewCell {
    //MARK: - Properties
    var option : SortOption? { didSet{ configure()}}
    private let selectImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icnRadio")?.withRenderingMode(.alwaysOriginal)
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [selectImageView, optionLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 8
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure(){
        optionLabel.text = option?.description
    }
}
