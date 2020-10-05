//
//  FavoriteCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol RestaurantListCellDelegate : class {
    func didSelectRestaurant(_ restaurant : Restaurant)
}

class RestaurantListCell : UITableViewCell {
    //MARK: - Properties
    weak var delegate : RestaurantListCellDelegate?
    var viewModel : CardCellViewModel? { didSet{ configure() }}
    private let optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .lightlightGray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let restaurantName : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.textAlignment = .left
        return label
    }()
    private let priceLabel = UILabel()
    lazy var selectButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectButtonTapped), for: .touchUpInside)
        return button
    }()
    private let ratedLabel = UILabel()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        optionImageView.anchor(left: leftAnchor, paddingLeft: 16, width: 88, height: 88)
        optionImageView.centerY(inView: self)
        addSubview(selectButton)
        selectButton.anchor(right: rightAnchor, paddingRight: 16,width: 48, height: 48)
        selectButton.centerY(inView: self)
        
        let captionStack = UIStackView(arrangedSubviews: [restaurantName, priceLabel, ratedLabel])
        captionStack.distribution = .fillEqually
        captionStack.spacing = 0
        captionStack.axis = .vertical
        addSubview(captionStack)
        captionStack.anchor(left: optionImageView.rightAnchor, right:selectButton.leftAnchor,
                            paddingLeft: 18, paddingRight: 8)
        captionStack.centerY(inView: self)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func handleSelectButtonTapped(){
        self.viewModel!.restaurant.isSelected.toggle()
        self.delegate?.didSelectRestaurant(self.viewModel!.restaurant)
    }
    //MARK: - Helpers
    func configure(){
        guard let viewModel = viewModel else { return }
        restaurantName.text = viewModel.restaurant.name
        priceLabel.attributedText = viewModel.priceString
        ratedLabel.attributedText = viewModel.ratedString
        optionImageView.af.setImage(withURL: viewModel.restaurant.imageUrl)
        selectButton.setImage(viewModel.selectButtonImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}



