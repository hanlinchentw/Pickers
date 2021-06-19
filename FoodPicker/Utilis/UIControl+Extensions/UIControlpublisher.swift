//
//  UIControlpublisher.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/17.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine

struct UIControlPublisher<Control: UIControl>: Publisher {
    
    typealias Output = Control
    typealias Failure = Never
    
    let control: Control
    let event: UIControl.Event
    
    init(control: Control, event: UIControl.Event) {
        self.control = control
        self.event = event
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: event)
        subscriber.receive(subscription: subscription)
    }
}
