//
//  PopupView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/15.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine

class PopupView : UIView {
    //MARK: - Properties
    var title: String
    var subtitle: String
    var withButton : Bool
    var buttonTitle: String?
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial-BoldMT", size: 28)
        label.textColor = .butterscotch
        label.text = title
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var subtitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 14)
        label.text = subtitle
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    public lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .butterscotch
        button.layer.cornerRadius = 20
        
        return button
    }()
    fileprivate lazy var stackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    fileprivate let containerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnCancelGreySmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancelButtonTapped), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    init(title: String, subtitle: String, withButton: Bool, buttonTitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.withButton = withButton
        self.buttonTitle = buttonTitle
        
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        self.frame = UIScreen.main.bounds
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        
        self.addSubview(containerView)
        containerView.center(inView: self)
        containerView.heightMultiplier(heightAnchor: self.heightAnchor, heightMultiplier: 0.25)
        containerView.widthMutiplier(widthAnchor: self.widthAnchor, widthMultiplier: 0.75)
        
        
        self.containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor,
                         paddingTop: 16, paddingLeft: 8, paddingRight: 8)
        stackView.heightMultiplier(heightAnchor: containerView.heightAnchor, heightMultiplier: 0.5)
        
        self.containerView.addSubview(cancelButton)
        cancelButton.anchor(top: containerView.topAnchor, right: containerView.rightAnchor,
                            paddingTop: 8, paddingRight: 8)
        if withButton {addingButtonIntoStackview()}
        animateIn()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Configure
    func addingButtonIntoStackview() {
        self.containerView.addSubview(actionButton)
        actionButton.anchor(top: stackView.bottomAnchor, paddingTop: 16)
        actionButton.centerX(inView: containerView)
        actionButton.widthMutiplier(widthAnchor: containerView.widthAnchor, widthMultiplier: 0.6)
        actionButton.heightMultiplier(heightAnchor: containerView.heightAnchor, heightMultiplier: 0.2)
    }
    //MARK: - Animation
    @objc func animateOut() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        } completion: { complete in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    @objc fileprivate func animateIn() {
        self.containerView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.containerView.transform = .identity
            self.alpha = 1
        }
    }
    @objc func handleCancelButtonTapped() {
        self.animateOut()
    }
}
