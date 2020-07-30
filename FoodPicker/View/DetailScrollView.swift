//
//  DetailScrollView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/25.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class DetailScrollView : UIScrollView {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
