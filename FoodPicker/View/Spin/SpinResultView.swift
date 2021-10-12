//
//  SpinResultView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/21.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

protocol SpinResultViewDelegate: AnyObject {
    func pushToDetailVC(restaurant: Restaurant)
}

class SpinResultView : UIView {
    //MARK: - Properties
    weak var delegate: SpinResultViewDelegate?
    var restaurant: Restaurant? { didSet{ self.configureResult(result: restaurant) }}
    private let nilResultImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "hungryGirl")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "What's for today?"
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        return label
    }()
    private lazy var optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private lazy var  restaurantName : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    private lazy var  businessLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .freshGreen
        return label
    }()
    private lazy var  priceLabel = UILabel()
    private lazy var  ratedLabel = UILabel()
    private lazy var containerView: UIStackView = {
        let labelStack = UIStackView(arrangedSubviews: [restaurantName, businessLabel, priceLabel, ratedLabel])
        labelStack.distribution = .fillProportionally
        labelStack.spacing = 4
        labelStack.axis = .vertical
        let stack = UIStackView(arrangedSubviews: [optionImageView, labelStack])
        stack.axis = .vertical
        stack.spacing = 8
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleResultViewTapped))
        stack.addGestureRecognizer(tap)
        stack.isUserInteractionEnabled = true
        return stack
    }()
    //MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        configureNilResultView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func handleResultViewTapped(){
        print(123)
        guard let result = self.restaurant else { return }
        delegate?.pushToDetailVC(restaurant: result)
    }
    //MARK: - Helpers
    func configureNilResultView(){
        addSubview(stateLabel)
        stateLabel.centerX(inView: self)
        stateLabel.anchor(top: self.topAnchor, paddingTop: 32)
        
        addSubview(nilResultImageView)
        let imageWidthAndHeight = 200 * self.heightMultiplier
        nilResultImageView.anchor(top: stateLabel.bottomAnchor, paddingTop: 16,
                                  width: imageWidthAndHeight, height: imageWidthAndHeight)
        nilResultImageView.centerX(inView: self)
    }

    private func configureResultView() {
        nilResultViewAnimateOut()
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        self.containerView.alpha = 0
        self.addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor,
                            paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 8)
        resultViewAnimateIn()
    }
    private func configureResult(result: Restaurant?) {
        configureResultView()
        guard let result = result else { return }
        let viewModel = CardCellViewModel(restaurant: result)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        restaurantName.text = result.name
        priceLabel.attributedText = viewModel.priceString
        ratedLabel.attributedText = viewModel.ratedString
        businessLabel.attributedText = viewModel.businessString
        optionImageView.af.setImage(withURL: result.imageUrl)
    }
    func nilResultViewAnimateOut(){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.nilResultImageView.alpha = 0
            self.stateLabel.alpha = 0
            self.alpha = 0
        }
    }
    func resultViewAnimateIn(){
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.alpha = 1
            self.containerView.alpha = 1
        }
    }
}
