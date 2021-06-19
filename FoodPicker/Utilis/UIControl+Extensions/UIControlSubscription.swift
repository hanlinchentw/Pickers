//
//  UIControlSubscription.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/17.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine

//這個類別是為了創造一個 Subscription 作為 UIControl 的 Target
//使事件（點擊）發生時，subscriber 可以接收該事件

final class UIControlSubscription <SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    
    private var subscriber: SubscriberType?
    private let control: Control
    
    
    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }
    func request(_ demand: Subscribers.Demand) {
        
    }
    
    func cancel() {
        subscriber = nil
    }
    
    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}
