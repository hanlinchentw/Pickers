//
//  IntroController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/16.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class IntroController : UIViewController {
    //MARK: - Properties
    private var introView = IntroView()
    
    private let backButton : UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(named: "icnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        LocationHandler.shared.enableLocationServices()
        configureIntroView()
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
extension IntroController : IntroViewDelegate {
    func didTapCreateButton() {
        let auth = AuthController()
        let nav = UINavigationController(rootViewController: auth)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
    }
}
