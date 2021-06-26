//
//  FavoriteCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

enum ListConfiguration{
    case sheet
    case table
    case edit
    case list
    case all
}

protocol RestaurantListCellDelegate : class {
    func didSelectRestaurant(_ restaurant : Restaurant)
    func shouldDeleteCell(_ restaurant: Restaurant)
}

extension RestaurantListCellDelegate{
    func didSelectRestaurant(_ restaurant : Restaurant){}
    func shouldDeleteCell(_ restaurant: Restaurant){}
}

class RestaurantListCell : UITableViewCell {
    //MARK: - Properties
    weak var delegate : RestaurantListCellDelegate?
    var config: ListConfiguration? { didSet{ configure()}}
    var viewModel : CardCellViewModel?
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
    lazy var actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    private let ratedLabel = UILabel()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        let imageHeight = 93 * widthMultiplier
        optionImageView.anchor(left: leftAnchor, paddingLeft: 16, width: imageHeight, height: imageHeight)
        optionImageView.centerY(inView: self)
        contentView.addSubview(actionButton)
        actionButton.anchor(right: rightAnchor, paddingRight: 16,width: 48, height: 48)
        actionButton.centerY(inView: self)
        
        let captionStack = UIStackView(arrangedSubviews: [restaurantName, priceLabel, ratedLabel])
        captionStack.distribution = .fillEqually
        captionStack.spacing = 0
        captionStack.axis = .vertical
        addSubview(captionStack)
        captionStack.anchor(left: optionImageView.rightAnchor, right: actionButton.leftAnchor,
                            paddingLeft: 18, paddingRight: 8)
        captionStack.centerY(inView: self)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.optionImageView.image = nil
        self.restaurantName.text = nil
        self.ratedLabel.text = nil
        self.priceLabel.text = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func handleActionButtonTapped(){
        guard let viewModel = viewModel else { return }
        if config == .edit{
            print("DEBUG: Should delete restaurant ... ")
            self.delegate?.shouldDeleteCell(viewModel.restaurant)
        }else{
            print("DEBUG: Did select restaurant ... from cell")
            self.viewModel!.restaurant.isSelected.toggle()
            print("DEBUG: Restaurant is Selected \(self.viewModel!.restaurant.isSelected)")
            self.delegate?.didSelectRestaurant(self.viewModel!.restaurant)
            self.actionButton.setImage(UIImage(named: self.viewModel!.selectButtonImagename)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    //MARK: - Helpers
    func configure(){
        guard let viewModel = viewModel, let config = config else { return }
        restaurantName.text = viewModel.restaurant.name
        priceLabel.attributedText = viewModel.priceString
        ratedLabel.attributedText = viewModel.ratedString
        optionImageView.af.setImage(withURL: viewModel.restaurant.imageUrl)
        if config == .table{
            backgroundColor = .backgroundColor
            changeImageWithAninamation(imageName: viewModel.selectButtonImagename)
        }else if config == .edit{
            changeImageWithAninamation(imageName: "icnDeleteNoShadow")
        }else if config == .list{
            backgroundColor = .backgroundColor
            actionButton.isHidden = true
        }else if config == .sheet || config ==  .all {
            self.actionButton.setImage(UIImage(named: viewModel.selectButtonImagename)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    func changeImageWithAninamation(imageName: String){
        self.actionButton.alpha = 0
        UIView.animate(withDuration: 1) {
            self.actionButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.actionButton.alpha = 1
            }
        }
    }
}



