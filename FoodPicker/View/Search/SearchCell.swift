//
//  SearchCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/23.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    //MARK: - Properties
    var term: String? { didSet{ titleLabel.text = term }}
    private let searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icnSearchSmall")?.withRenderingMode(.alwaysOriginal)
        iv.setDimension(width: 24, height: 24)
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 16)
        label.text = "Test"
        label.textColor = . black
        return label
    }()

    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundColor
        
        let stack = UIStackView(arrangedSubviews: [searchImageView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillProportionally
        addSubview(stack)
        stack.anchor(left: leftAnchor, paddingLeft: 16)
        stack.centerY(inView: self)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
