//
//  IntroController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/16.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Combine

class IntroController : UIViewController {
    //MARK: - Properties
    private let introView = IntroView()
    private let backButton : UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(named: "icnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    private var subscriber = Set<AnyCancellable>()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: Loading Intro view controller ")
        self.navigationController?.navigationBar.isHidden = true
        configureIntroView()
        LocationHandler.shared.enableLocationServices()
        
    }
    //MARK: - Seletors
    @objc func handleBackButtonTapped(){
        UIView.animate(withDuration: 0.3) {
            self.introView.frame.origin.x += self.view.frame.width
        }
    }
    //MARK: - Helpers
    func configureIntroView(){
        view.addSubview(introView)
        introView.frame = view.bounds
        introView.delegate = self
    }
}
extension IntroController : IntroViewDelegate{
    func didTapCreateButton() {
        if !NetworkMonitor.shared.isConnected {
            self.presentIntrernetErrorPopViewAndProvidePublisher().store(in: &subscriber)
        }else{
            let auth = AuthController()
            self.navigationController?.pushViewController(auth, animated: true)
        }
    }
        
}
