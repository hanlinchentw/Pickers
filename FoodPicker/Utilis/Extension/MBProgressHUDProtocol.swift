//
//  MBProgressHUDProtocol.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/11.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol MBProgressHUDProtocol where Self:UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

extension MBProgressHUDProtocol {
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
