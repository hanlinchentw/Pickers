//
//  Coordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/5.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
