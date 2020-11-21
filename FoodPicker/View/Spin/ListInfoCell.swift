//
//  ListInfoCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/18.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class ListInfoCell: UITableViewCell{
    //MARK: - Properties
    var list: List? { didSet { configure() }}
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Arial-BoldMT", size:16)
        label.textColor = .black
        return label
    }()
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"ArialMT", size:14)
        label.textColor = .gray
        return label
    }()
    
    private let restaurantsNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"ArialMT", size:14)
        label.textColor = .black
        return label
    }()
    private let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icnMoreThreeDot")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimension(width: 40, height: 40)
        return button
    }()
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icnArrowDown")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimension(width: 40, height: 40)
        return button
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, timestampLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        addSubview(stack)
        stack.anchor(top:self.topAnchor, left: leftAnchor,
                         paddingTop: 16, paddingLeft: 16)
        
        addSubview(restaurantsNumLabel)
        restaurantsNumLabel.anchor(left: leftAnchor, bottom: bottomAnchor, 
                                   paddingLeft: 16, paddingBottom: 16)
        
        let buttonStack = UIStackView(arrangedSubviews: [optionButton, expandButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 22
        addSubview(buttonStack)
        buttonStack.anchor(right: rightAnchor, paddingRight: 8)
        buttonStack.centerY(inView: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure(){
        guard let list = list else { return }
        nameLabel.text = list.name
        restaurantsNumLabel.text = "\(list.count) restaurants"
        
        let date = Date(timeIntervalSince1970: list.timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let day = dateFormatter.string(from: date)
        timestampLabel.text = day
    }
}
