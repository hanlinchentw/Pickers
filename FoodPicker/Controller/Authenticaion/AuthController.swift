//
//  SignUpController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/16.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

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

class AuthController : UIViewController{
    //MARK: - Properties
    private var status : AccountStatus? { didSet{ configure()}}
    
    private var introView = IntroView()
    private let backButton : UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(named: "icnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()

    private let emailTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: false)
        
        return tf
    }()
    
    private lazy var emailInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Email", textField: emailTextField)
        return view
    }()
    private let passwordTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: true)
        return tf
    }()
    
    private lazy var passwordInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Password", textField: passwordTextField)
        view.alpha = 0
        return view
    }()
    private let confirmPasswordTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: true)
        return tf
    }()
    
    private lazy var confirmPasswordInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Confirm Password", textField: confirmPasswordTextField)
        view.alpha = 0
        
        return view
    }()
    
    private let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 14)
        button.tintColor = .black
        button.backgroundColor = .pale
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Selectors
    @objc func handleBackButtonTapped(){
        guard status != nil else{
            navigationController?.popViewController(animated: true)
            return
        }
        self.status = nil
    }
    @objc func handleActionButtonTapped(){
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let status = status else{
            UserService.shared.checkIfUserIsExisted(withEmail: email, completion: { isExisted in
                guard isExisted == true else {
                self.status = .register
                    return
                }
                self.status = .login
            })
            return 
        }
        guard let password = passwordTextField.text else { return }
        switch status {
        case .register:
            print("DEBUG: Start to create account")
            guard confirmPasswordTextField.text == password else {
                print("DEUBG: Different with previous one...")
                return
            }
            print(0)
            UserService.shared.createUser(withEmail: email, password: password, completion: { (err, ref) in
                print(1)
                guard let window  = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
                guard let tab = window.rootViewController as? HomeController else { return }
                print(2)
                tab.authenticateUserAndConfigureUI()
                
                self.dismiss(animated: true, completion: nil)
            })
        case .login:
            print("DEBUG: Start to log in")
            UserService.shared.logUserIn(withEmail: email, password: password) { (result, err) in
                if let err = err {
                    print("Failed to log in...with \(err.localizedDescription)")
                }
                guard let window  = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
                guard let tab = window.rootViewController as? HomeController else { return }
                
                tab.authenticateUserAndConfigureUI()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(emailInputView)
        emailInputView.anchor(width: 300)
        emailInputView.centerY(inView: view, yConstant: -200)
        emailInputView.centerX(inView: view)
        
        view.addSubview(passwordInputView)
        view.addSubview(confirmPasswordInputView)
        
        passwordInputView.anchor(width: 300)
        passwordInputView.centerX(inView: emailInputView)
        passwordInputView.centerY(inView: emailInputView, yConstant: 100)
        confirmPasswordInputView.anchor(width: 300)
        confirmPasswordInputView.centerX(inView: emailInputView)
        confirmPasswordInputView.centerY(inView: emailInputView, yConstant: 200)
        
        view.addSubview(actionButton)
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        actionButton.frame = CGRect(x: screenWidth/2 - 100, y: screenHeight/2 - 130, width: 200, height: 60)
        
        
        view.addSubview(backButton)
        backButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          paddingTop: 16, paddingLeft: 16,
                          width: 36, height:36)
    }
    func configure(){
        guard let status = status else{
            passwordInputView.alpha = 0
            confirmPasswordInputView.alpha = 0
            actionButton.setTitle("Next", for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                let screenWidth = self.view.frame.width
                let screenHeight = self.view.frame.height
                self.actionButton.frame = CGRect(x: screenWidth/2 - 100, y: screenHeight/2 - 130,
                width: 200, height: 60)
            }
            
            return
        }
        actionButton.setTitle(status.buttonTitle, for: .normal)
        switch status {
        case .register:
            UIView.animate(withDuration: 0.3, animations: {
                self.passwordInputView.alpha = 1
                self.confirmPasswordInputView.alpha = 1
                self.actionButton.frame.origin.y += 200
            }, completion: nil)
        case .login:
            UIView.animate(withDuration: 0.3, animations: {
                self.passwordInputView.alpha = 1
                self.actionButton.frame.origin.y += 100
            }, completion: nil)
        }
    }
}

