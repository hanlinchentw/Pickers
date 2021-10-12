//
//  ActionSheetFooter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/10/7.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

protocol SheetFooterDelegate: AnyObject {
    func didTapApplyButton()
}

class SheetFooter: UICollectionReusableView {
    weak var delegate : SheetFooterDelegate?
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ctaYActive")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleApplyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(applyButton)
        applyButton.centerY(inView: self)
        applyButton.anchor(left: leftAnchor, right: rightAnchor,
                           paddingLeft: 32, paddingRight: 32)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleApplyButtonTapped(){
        delegate?.didTapApplyButton()
    }
}


