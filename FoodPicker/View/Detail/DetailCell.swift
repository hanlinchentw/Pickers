//
//  DetailScrollView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/25.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import MapKit

enum RestaurantDetail : Int, CaseIterable {
    case main = 0
    case businessHour
    case address
    case phone
}

protocol DetailCellDelegate : class {
    func shouldCellExpand(_ isExpanded: Bool, config: RestaurantDetail)
    func didTapMapOption(name: String, coordinate: CLLocationCoordinate2D)
}
class DetailCell : UICollectionViewCell {
    //MARK: - Properties
    weak var delegate : DetailCellDelegate?
    var config : RestaurantDetail?
    var viewModel : DetailCellViewModel? { didSet{ configure()}}
    
    private let iconImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let titleLabel : UILabel = {
           let label = UILabel()
           label.font = UIFont.arialBoldMT
           return label
    }()
   
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.arialMT
        label.text = "No Providing"
        label.numberOfLines = 0
        return label
    }()
    
    private let numOfPeopleLikeLabel = UILabel()
    private lazy var likeView : UIView = {
        let view = UIView()
        view.isHidden = true
        let likeImageView = UIImageView()
        likeImageView.image = UIImage(named: "icnHeartXs")
        likeImageView.contentMode = .scaleAspectFit
        view.addSubview(likeImageView)
        likeImageView.anchor(top:view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                             width: 16, height: 16)
        
        
        numOfPeopleLikeLabel.font = UIFont.arialMT
        numOfPeopleLikeLabel.textColor = .gray
        view.addSubview(numOfPeopleLikeLabel)
        numOfPeopleLikeLabel.anchor(top:view.topAnchor, left: likeImageView.rightAnchor,
                     right: view.rightAnchor, bottom: view.bottomAnchor,
                     paddingLeft: 4)
        
        return view
    }()
    private let ratingLabel = UILabel()
    private let reviewCountLabel = UILabel()
    private lazy var ratingAndReviewView: UIView = {
        let view = UIView()
        view.isHidden = true
        let starIconImageView = UIImageView()
        starIconImageView.image = UIImage(named: "ratingStarXs")
        starIconImageView.contentMode = .scaleAspectFit
        view.addSubview(starIconImageView)
        starIconImageView.anchor(top:view.topAnchor, left:view.leftAnchor,
                                 bottom: view.bottomAnchor, width:16, height: 16)
        
        ratingLabel.font = .arialMT
        ratingLabel.text = "4.9"
        ratingLabel.textColor = .customblack
        view.addSubview(ratingLabel)
        ratingLabel.anchor(top:view.topAnchor, left: starIconImageView.rightAnchor,
                           right: view.rightAnchor, bottom: view.bottomAnchor,
                           paddingLeft: 4)
        
        reviewCountLabel.font = .arialMT
        reviewCountLabel.text = "(500+)"
        reviewCountLabel.textColor = .gray
        
        view.addSubview(reviewCountLabel)
        reviewCountLabel.anchor(top:view.topAnchor, left: starIconImageView.rightAnchor,
                                right: view.rightAnchor, bottom: view.bottomAnchor,
                                paddingLeft: 29)
        return view
    }()
    
    private lazy var menuButton : UIButton = {
        let button = UIButton(type: .system).createViewWithRoundedCornerAndShadow(withText: "Menu")
        return button
    }()
    
    private lazy var actionButton : UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.customblack.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        
        let shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.cornerRadius = 12
        shadowView.layer.masksToBounds = true
        
        view.addSubview(shadowView)
        shadowView.fit(inView: view)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleActionButtonTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    var isExpanded = false
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let titleStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        
        addSubview(titleStack)
        titleStack.anchor(top:topAnchor, left: leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        
        addSubview(actionButton)
        actionButton.anchor(top:topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 16)
        
        let subtitleStack = UIStackView(arrangedSubviews: [likeView, subtitleLabel])
        subtitleStack.axis = .vertical
        subtitleStack.spacing = 8
        addSubview(subtitleStack)
        subtitleStack.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right:rightAnchor,
                            paddingTop: 4, paddingLeft: 16, paddingRight: 100)
        
        addSubview(menuButton)
        menuButton.anchor(left:leftAnchor, bottom: bottomAnchor,
                          paddingLeft: 16, paddingBottom: 16,
                          width: 77, height: 44 )
        
        addSubview(ratingAndReviewView)
        ratingAndReviewView.anchor(right: rightAnchor, paddingRight: 12)
        ratingAndReviewView.centerY(inView: titleLabel)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func handleActionButtonTapped(){
        guard let config = config else { return }
        switch config {
        case .businessHour:
            isExpanded.toggle()
            delegate?.shouldCellExpand(isExpanded, config: config)
            print("DEBUG: Show business hour...")
        case .address:
            print("DEBUG: Show address...")
            guard let restaurant = viewModel?.restaurant else { return }
            delegate?.didTapMapOption(name: restaurant.name, coordinate: restaurant.coordinates)
        case .phone:
            guard let phoneNumberString = viewModel?.phoneSub else { return }
            guard let phoneNumberURL = URL(string : phoneNumberString) else { return }
            UIApplication.shared.open(phoneNumberURL)
        default: break
        }
    }
    //MARK: - Helpers
    func configure(){
        guard let viewModel = viewModel else { return }
        
        numOfPeopleLikeLabel.text = "\(viewModel.numOfLike) people’s favorite"
        ratingLabel.text = "\(viewModel.rating)"
        reviewCountLabel.text = "(\(viewModel.reviewCount))"
        titleLabel.text = viewModel.titleText
        subtitleLabel.attributedText = viewModel.subtitleText
        iconImageView.image = UIImage(named: viewModel.iconImageName)
        actionButton.image = UIImage(named: viewModel.actionButtonImageName)?.withRenderingMode(.alwaysOriginal)
        
        iconImageView.isHidden = viewModel.isMenu
        actionButton.isHidden = viewModel.isMenu
        likeView.isHidden = !viewModel.isMenu
        menuButton.isHidden = !viewModel.isMenu
        ratingAndReviewView.isHidden = !viewModel.isMenu
        actionButton.layer.shadowOpacity = viewModel.shouldShadowTurnOff ?  0 : 0.2
    }
}


