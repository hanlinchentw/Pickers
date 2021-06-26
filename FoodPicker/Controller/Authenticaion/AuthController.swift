//
//  SignUpController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/16.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import FirebaseAuth
import Combine

enum AccountStatus : CaseIterable{
    case register
    case login
    
    var buttonTitle : String {
        switch self {
        case .register : return "Create Account"
        case .login : return "Log in"
        }
    }
}

class AuthController : UIViewController, MBProgressHUDProtocol{
    //MARK: - Properties
    private var subscriber = Set<AnyCancellable>()
    @Published private var status : AccountStatus?

    private let backButton : UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(named: "btnCancelGreySmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "What's your Email?"
        label.textColor = .butterscotch
        label.textAlignment = .center
        label.font = UIFont(name: "Arial-BoldMT", size: 24)
        return label
    }()
    
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Please enter your email. We will help you find out if the email was registered or not."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .customblack
        label.font = UIFont(name: "ArialMT", size: 16)
        return label
    }()
    private let inValidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 14)
        label.text = "Incorrect format of email address"
        label.textColor = .errorRed
        label.alpha = 0
        return label
    }()
    private let emailTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: false)
        return tf
    }()
    
    private lazy var editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icnEditSmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleEditButtonTapped), for: .touchUpInside)
        button.setDimension(width: 24, height: 24)
        return button
    }()
    
    private lazy var emailInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Email", textField: emailTextField)
        view.addSubview(editButton)
        editButton.anchor(right: emailTextField.rightAnchor, paddingRight: 16)
        editButton.centerY(inView: emailTextField)
        editButton.isHidden = true
        return view
    }()
    private lazy var actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
        button.tintColor = .white
        button.backgroundColor = UIColor(white: 238/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    var registerVC : RegisterViewController?
    var loginVC : LoginViewController?
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        observeStatus()
        observeEmaillTextField()
    }
    //MARK: - Observer
    private func observeStatus() {
        self.$status.sink(receiveValue: { [weak self] status in
                switch status {
                case .register:
                    self?.configureRegisterPage()
                case .login:
                    self?.configureLoginPage()
                case .none:
                    self?.configureVerifyPage()
                }
            }).store(in: &subscriber)
    }
    private func observeEmaillTextField() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink {[weak self] email in
                let emailIsValid = Validators.email.validate(email)
                if emailIsValid {
                    self?.inValidLabel.alpha = 0
                    self?.emailTextField.layer.borderColor = UIColor.butterscotch.cgColor
                    self?.actionButton.backgroundColor = .butterscotch
                    self?.actionButton.isUserInteractionEnabled = true
                }else {
                    self?.inValidLabel.alpha = 1
                    self?.emailTextField.layer.borderColor = UIColor.errorRed.cgColor
                    self?.actionButton.backgroundColor = UIColor(white: 238/255, alpha: 1)
                    self?.actionButton.isUserInteractionEnabled = false
                }
            }.store(in: &subscriber)
    }
    private func observeLoginResult() {
        guard let loginVC = self.loginVC else { return }
        loginVC.$isSuccessfullyLogin.sink { [weak self] isSuccess in
            switch isSuccess {
            case true: self?.presentHomeVC()
            default: break
            }
        }.store(in: &subscriber)
    }
    private func observeRegisterResult() {
        guard let registerVC = self.registerVC else { return }
        registerVC.$isSuccessfullyRegistered.sink { [weak self] isSuccess in
            switch isSuccess {
            case true: self?.presentHomeVC()
            default: break
            }
        }.store(in: &subscriber)
    }
    //MARK: - Selectors
    @objc func handleBackButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleActionButtonTapped(){
        self.showLoadingAnimation()
        guard let email = emailTextField.text else { return }
        if status == nil {
            UserService.shared.checkIfUserIsExisted(withEmail: email, completion: { [weak self] isExisted, error in
                if let error = error {
                    switch error {
                    case .noInternet:
                        self?.presentPopView()
                    default:
                        break
                    }
                }
                self?.status = isExisted! ? .login : .register
            })
        }
    }
    private func presentHomeVC(){
        let homeVC = HomeController()
        homeVC.modalPresentationStyle = .fullScreen
        homeVC.modalTransitionStyle = .crossDissolve
        self.present(homeVC, animated: true, completion: nil)
        self.hideLoadingAnimation()
    }
    @objc func handleEditButtonTapped(){
        self.status = nil
    }
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
       
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStack.spacing = 4
        titleStack.axis = .vertical
        view.addSubview(titleStack)
        titleStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor,
                          paddingTop:56, paddingLeft: 39, paddingRight: 39)
        titleStack.centerX(inView: view)
        
        view.addSubview(emailInputView)
        emailInputView.anchor(top: titleStack.bottomAnchor, left: titleStack.leftAnchor, right: titleStack.rightAnchor,
                              paddingTop: 36)
        emailInputView.centerX(inView: view)
        
        view.addSubview(actionButton)
        actionButton.anchor(top: emailInputView.bottomAnchor, left: titleStack.leftAnchor,
                            right: titleStack.rightAnchor, paddingTop: 88, height: 48)
        actionButton.centerX(inView: emailInputView)
        
        view.addSubview(backButton)
        backButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor,
                          paddingTop: 16, paddingRight: 16)
    }
    func configureVerifyPage(){
        emailTextField.layer.borderColor = UIColor.butterscotch.cgColor
        emailTextField.isUserInteractionEnabled = true
        editButton.isHidden = true
        
        self.registerVC?.view.isHidden = true
        self.loginVC?.view.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.isHidden = false
            self.actionButton.isHidden = true
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.subtitleLabel.alpha = 1
                self.titleLabel.text = "What's your email?"
                self.titleLabel.alpha = 1
                self.actionButton.isHidden = false
                self.actionButton.isUserInteractionEnabled = true
            }
        }
        view.addSubview(inValidLabel)
        inValidLabel.anchor(top:emailInputView.bottomAnchor,
                            left: emailInputView.leftAnchor, paddingLeft: 8)
    }

    func configureRegisterPage(){
        self.hideLoadingAnimation()
        guard let email = emailTextField.text else { return }
        self.registerVC = RegisterViewController(email: email)
        guard let registerVC = self.registerVC else { return }
        self.addChild(registerVC)
        self.view.addSubview(registerVC.view)
        registerVC.didMove(toParent: self)
        registerVC.view.anchor(top: emailInputView.bottomAnchor, left: emailInputView.leftAnchor,
                                    right: emailInputView.rightAnchor, bottom: self.view.bottomAnchor)
        
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.isUserInteractionEnabled = false
        editButton.isHidden = false
        self.actionButton.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.registerVC?.view.isHidden = false
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.subtitleLabel.isHidden = true
                self.titleLabel.text = "Set up Your Account"
                self.titleLabel.alpha = 1
                self.registerVC?.view.alpha = 1
            }
        }
        observeRegisterResult()
    }
    func configureLoginPage(){
        self.hideLoadingAnimation()
        guard let email = emailTextField.text else { return }
        self.loginVC = LoginViewController(email: email)
        guard let loginVC = loginVC else  { return }
        self.addChild(loginVC)
        self.view.addSubview(loginVC.view)
        loginVC.didMove(toParent: self)
        loginVC.view.anchor(top: emailInputView.bottomAnchor, left: emailInputView.leftAnchor,
                                    right: emailInputView.rightAnchor, bottom: self.view.bottomAnchor)
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.isUserInteractionEnabled = false
        editButton.isHidden = false
        self.actionButton.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.loginVC?.view.isHidden = false
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.subtitleLabel.isHidden = true
                self.titleLabel.text = "Log In"
                self.titleLabel.alpha = 1
                self.loginVC?.view.alpha = 1
            }
        }
        observeLoginResult()
    }
    private func presentPopView() {
        self.presentPopupViewWithButtonAndProvidePublisher(title: "No Internet", subtitle: "Please Check your Internet Connection", buttonTitle: "Go Setting")
            .sink { _ in
                guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingURL, options: [:])
            }.store(in: &subscriber)
    }
}

