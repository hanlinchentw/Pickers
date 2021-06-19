//
//  UIControl+Extensions.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/15.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine

protocol CombineCompatible {}
extension UIControl : CombineCompatible{}

extension CombineCompatible  where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<Self> {
        return  UIControlPublisher(control: self, event: events)
    }
}

