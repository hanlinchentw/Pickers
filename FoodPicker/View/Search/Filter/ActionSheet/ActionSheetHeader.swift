//
//  ActionSheetHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/10/7.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

class SheetHeader: UICollectionReusableView {
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        return label
    }()
    private let notchView : UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.setDimension(width: 50, height: 5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(notchView)
        notchView.anchor(top:topAnchor, paddingTop: 7)
        notchView.centerX(inView: self)
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 24, paddingLeft: 24)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureTitle(title: String) {
        self.label.text = title
    }
}
