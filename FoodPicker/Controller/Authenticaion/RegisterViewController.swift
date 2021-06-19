//
//  RegisterViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/14.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit
import Combine

class RegisterViewController : UIViewController, MBProgressHUDProtocol {
    //MARK: - Properties
    var email: String
    private let passwordTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: true)
        tf.placeholder = "Enter Your password"
        return tf
    }()
    private lazy var passwordInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Password", textField: passwordTextField)
        return view
    }()
    private lazy var passwordRequirementLabel1 : UILabel = {
        let text = "6 to 20 characters"
        let label = UILabel()
        label.attributedText = text.attributedStringWithBullet
        label.textColor = .lightGray
        label.font = UIFont(name: "ArialMT", size: 12)
        return label
    }()
    private lazy var passwordRequirementLabel2 : UILabel = {
        let text = "Texts and numbers only"
        let label = UILabel()
        label.attributedText = text.attributedStringWithBullet
        label.textColor = .lightGray
        label.font = UIFont(name: "ArialMT", size: 12)
        return label
    }()
    private let confirmPasswordTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: true)
        tf.placeholder = "Enter Your password again"
        return tf
    }()
    private lazy var confirmPasswordInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Confirm Password", textField: confirmPasswordTextField)
        return view
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
        button.tintColor = .white
        button.backgroundColor = UIColor(white: 238/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(handleRegisterButtonTapped), for: .touchUpInside)
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
    private var subscriber = Set<AnyCancellable>()
    @Published var isSuccessfullyRegistered : Bool?
    //MARK: - Lifecycle
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.email = ""
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        observePasswordTF()
        observeConfirmPasswordTF()
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.passwordTextField.becomeFirstResponder()
    }
    //MARK: -  Observer
    private func observePasswordTF() {
        passwordTextField.textPublisher
            .sink {[weak self] text in
                guard let text = text else { return }
                let passwordIsValid = Validators.password.validate(text)
                if passwordIsValid {
                    let text1 = "6 to 20 characters"
                    let text2 = "Texts and numbers only"
                    self?.passwordRequirementLabel1.attributedText = text1.attributedStringWithCheckmark
                    
                    self?.passwordRequirementLabel2.attributedText = text2.attributedStringWithCheckmark
                    self?.passwordRequirementLabel1.textColor = .freshGreen
                    self?.passwordRequirementLabel2.textColor = .freshGreen
                }else{
                    let text1 = "6 to 20 characters"
                    let text2 = "Texts and numbers only"
                    self?.passwordRequirementLabel1.attributedText = text1.attributedStringWithBullet
                    self?.passwordRequirementLabel2.attributedText = text2.attributedStringWithBullet
                    self?.passwordRequirementLabel1.textColor = .gray
                    self?.passwordRequirementLabel2.textColor = .gray
                }
            }.store(in: &subscriber)
    }
    private func observeConfirmPasswordTF() {
        confirmPasswordTextField.textPublisher
            .sink { [weak self] text in
                guard let text = text else { return }
                guard let password = self?.passwordTextField.text else { return }
                if text == password {
                    self?.inValidLabel.alpha = 0
                    self?.registerButton.isUserInteractionEnabled = true
                    self?.registerButton.backgroundColor = .butterscotch
                    self?.confirmPasswordTextField.layer.borderColor = UIColor.butterscotch.cgColor
                }else {
                    self?.inValidLabel.alpha = 1
                    self?.confirmPasswordTextField.layer.borderColor = UIColor.errorRed.cgColor
                    self?.registerButton.backgroundColor = UIColor(white: 238/255, alpha: 1)
                    self?.registerButton.isUserInteractionEnabled = false
                }
            }.store(in: &subscriber)
    }
    //MARK: -  Helper
    private func configure() {
        let passwordStack = UIStackView(arrangedSubviews: [passwordInputView, passwordRequirementLabel1, passwordRequirementLabel2,confirmPasswordInputView])
        passwordStack.spacing = 8
        passwordStack.axis = .vertical
        
        self.view.addSubview(passwordStack)
        passwordStack.anchor(top: self.view.topAnchor,
                             left: self.view.leftAnchor,
                             right: self.view.rightAnchor,
                             paddingTop: 20)
        
        self.view.addSubview(registerButton)
        registerButton.anchor(top: passwordStack.bottomAnchor,
                              left: self.view.leftAnchor,
                              right: self.view.rightAnchor,
                              paddingTop: 32)
        registerButton.heightMultiplier(heightAnchor: self.view.heightAnchor, heightMultiplier: 0.08)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.passwordInputView.alpha = 1
            self.confirmPasswordInputView.alpha = 1
        })
        view.addSubview(inValidLabel)
        inValidLabel.anchor(top:confirmPasswordInputView.bottomAnchor,
                            left: confirmPasswordInputView.leftAnchor, paddingLeft: 8)
    }
    @objc func handleRegisterButtonTapped() {
        guard let password = self.passwordTextField.text else { return }
        register(withEmail: email, withPassword: password)
    }
    //MARK: -  FireAuth API
    private func register(withEmail email : String, withPassword password: String) {
        self.showLoadingAnimation()
        UserService.shared.createUser(withEmail: email, password: password) { [weak self] result in
            self?.hideLoadingAnimation()
            switch result {
            case .success(_): self?.isSuccessfullyRegistered = true
            case .failure(let error):
                self?.isSuccessfullyRegistered = false
                switch error {
                case .invaildPassword: self?.inValidLabel.text = "Invalid Password"
                case .noInternet: self?.inValidLabel.text = "No Internet Connected"
                case .serverError: self?.inValidLabel.text = "Server Error, Please try again"
                }
            }
        }
    }
}

