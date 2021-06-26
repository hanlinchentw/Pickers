//
//  LoginViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/14.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine

class LoginViewController: UIViewController, MBProgressHUDProtocol {
    //MARK: - Prorperties
    
    let email: String
    private let passwordTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: true)
        tf.placeholder = "Enter Your password"
        return tf
    }()
    private lazy var passwordInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Password", textField: passwordTextField)
        return view
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
        button.tintColor = .white
        button.backgroundColor = .butterscotch
        button.layer.cornerRadius = 12
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    private let inValidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 14)
        label.textColor = .errorRed
        label.alpha = 0
        label.text = "Password didn't match"
        return label
    }()
    
    @Published var isSuccessfullyLogin: Bool?
    private var subscriber = Set<AnyCancellable>()
    //MARK: - Lifecycle
    init(email:String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.passwordTextField.becomeFirstResponder()
    }
    //MARK: - Helpers
    private func configure(){
        view.addSubview(passwordInputView)
        passwordInputView.anchor(top: self.view.topAnchor,
                                 left: self.view.leftAnchor,
                                 right: self.view.rightAnchor,
                                 paddingTop: 37)
        view.addSubview(loginButton)
        loginButton.anchor(top: passwordInputView.bottomAnchor, left: self.view.leftAnchor,
                           right: self.view.rightAnchor, paddingTop: 76, height: 48)
        UIView.animate(withDuration: 0.3, animations: {
            self.passwordInputView.alpha = 1
        })
        view.addSubview(inValidLabel)
        inValidLabel.anchor(top:passwordInputView.bottomAnchor,
                            left: passwordInputView.leftAnchor, paddingLeft: 8)
    }
    private func presentPopViewAndSubscibeIt() {
        self.presentPopupViewWithButtonAndProvidePublisher(title: "No Internet", subtitle: "Please Check your Internet Connection", buttonTitle: "Go Setting")
            .sink { _ in
                guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingURL, options: [:])
            }.store(in: &subscriber)
    }
    //MARK: - Selectors
    @objc func handleLoginButtonTapped(){
        guard let password = self.passwordTextField.text else { return }
        self.logIn(withEmail: email, withPassword: password)
    }
    //MARK: -  FireAuth
    private func logIn(withEmail email:String, withPassword password: String) {
        self.showLoadingAnimation()
        UserService.shared.logUserIn(withEmail: email, password: password) { [weak self] result in
            switch result {
            case .success( _):
                self?.isSuccessfullyLogin = true
                self?.hideLoadingAnimation()
            case .failure(let error):
                switch error {
                case .incorrectPassword: self?.inValidLabel.text = "Incorrect Password"
                case .noInternet:
                    self?.inValidLabel.text = "No Internet Connected"
                    self?.presentPopViewAndSubscibeIt()
                case .serverError: self?.inValidLabel.text = "Server Error, Please try again"
                }
                UIView.animate(withDuration: 0.5,animations: {
                    self?.inValidLabel.alpha = 1
                    self?.passwordTextField.layer.borderColor = UIColor.errorRed.cgColor
                }) { _ in
                UIView.animate(withDuration: 1) {
                    self?.inValidLabel.alpha = 0
                    self?.passwordTextField.layer.borderColor = UIColor.butterscotch.cgColor
                } }
                self?.isSuccessfullyLogin = false
                self?.hideLoadingAnimation()
            }
        }
    }
}
