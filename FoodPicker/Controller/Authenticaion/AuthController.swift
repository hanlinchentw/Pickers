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
    private var status : AccountStatus? {
        didSet{
            switch self.status {

            case .login: self.configureLoginPage()
            case .register: self.configureRegisterPage()
            case .none: self.configureVerifyPage()
            }
        }
    }
    
    private var introView = IntroView()
    
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
        label.text = "Please enter your email. We will help you find out if the email was registered of not."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .customblack
        label.font = UIFont(name: "ArialMT", size: 16)
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
    
    private let passwordRequirementImageView1 = UIImageView()
    private let passwordRequirementImageView2 = UIImageView()
    private let passwordRequirementLabel1 : UILabel = {
        let label = UILabel()
        label.text = "6 to 20 characters"
        return label
    }()
    
    private let passwordRequirementLabel2 : UILabel = {
        let label = UILabel()
        label.text = "Texts and numbers only"
        return label
    }()
    
    private lazy var passwordRequirementView1 = UIView().createPasswordRequirementView(imageView: passwordRequirementImageView1 , label: passwordRequirementLabel1)
    
    private lazy var passwordRequirementView2 = UIView().createPasswordRequirementView(imageView: passwordRequirementImageView2 , label: passwordRequirementLabel2)
    
    private let passwordTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: true)
        tf.placeholder = "Enter Your password"
        return tf
    }()
    
    private lazy var passwordInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Password", textField: passwordTextField)
        view.alpha = 0
        return view
    }()
    private let confirmPasswordTextField : UITextField = {
        let tf = UITextField().inputTextField(isSecured: true)
        tf.placeholder = "Enter Your password again"
        return tf
    }()
    
    private lazy var confirmPasswordInputView : UIView = {
        let view = UIView().createInputView(withTitle: "Confirm Password", textField: confirmPasswordTextField)
        view.alpha = 0
        return view
    }()
    
    private let actionButton : UIButton = {
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Selectors
    @objc func handleBackButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleActionButtonTapped(){
        guard let email = emailTextField.text else { return }
        let inValidLabel = UILabel()
        
        inValidLabel.font = UIFont(name: "ArialMT", size: 14)
        inValidLabel.textColor = .errorRed
        inValidLabel.alpha = 0
        view.addSubview(inValidLabel)
        if status == nil {
            UserService.shared.checkIfUserIsExisted(withEmail: email, completion: { isExisted in
                if isExisted {
                    self.status = .login
                }else {
                    self.status = .register
                }
            })
        }else if status == .login {
            guard let password = passwordTextField.text else { return }
            inValidLabel.text = "Incorrect password"
            inValidLabel.anchor(top:passwordInputView.bottomAnchor,
                                left: passwordInputView.leftAnchor, paddingLeft: 8)
            UserService.shared.logUserIn(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    UIView.animate(withDuration: 2, animations: {
                        inValidLabel.alpha = 1
                        self.passwordTextField.layer.borderColor = UIColor.errorRed.cgColor
                    }) { _ in
                        UIView.animate(withDuration: 0.5) {
                            inValidLabel.alpha = 0
                            self.passwordTextField.layer.borderColor = UIColor.butterscotch.cgColor
                        }
                    }
                }
                guard let window  = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
                guard let tab = window.rootViewController as? HomeController else { return }
                
                tab.authenticateUserAndConfigureUI()
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }else if status == .register {
            guard let password = passwordTextField.text else { return }
            guard let confirm = confirmPasswordTextField.text else { return }
            inValidLabel.text = "Password didn't match"
            inValidLabel.anchor(top:confirmPasswordInputView.bottomAnchor,
                                left: confirmPasswordInputView.leftAnchor, paddingLeft: 8)
            
            if password == confirm {
                UserService.shared.createUser(withEmail: email, password: password) { (err, ref) in
                    print("DEBUG: Success to register")
                    guard let window  = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
                    guard let tab = window.rootViewController as? HomeController else { return }
                    
                    tab.authenticateUserAndConfigureUI()
                    
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }else {
                UIView.animate(withDuration: 1.5, animations: {
                    inValidLabel.alpha = 1
                    self.passwordTextField.layer.borderColor = UIColor.errorRed.cgColor
                    self.confirmPasswordTextField.layer.borderColor = UIColor.errorRed.cgColor
                }) { _ in
                    UIView.animate(withDuration: 1.5) {
                        inValidLabel.alpha = 0
                        self.passwordTextField.layer.borderColor = UIColor.butterscotch.cgColor
                        self.confirmPasswordTextField.layer.borderColor = UIColor.butterscotch.cgColor

                    }
                }
            }
        }
    }
    @objc func handleEditButtonTapped(){
        self.status = nil
    }
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStack.spacing = 4
        titleStack.axis = .vertical
        view.addSubview(titleStack)
        titleStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop:56, width: 336)
        titleStack.centerX(inView: view)
        
        view.addSubview(emailInputView)
        emailInputView.anchor(top: titleStack.bottomAnchor, paddingTop: 36, width: 336, height: 72)
        emailInputView.centerX(inView: view)
        
        view.addSubview(actionButton)
        actionButton.anchor(top: emailInputView.bottomAnchor, paddingTop: 88, width: 336, height: 48)
        actionButton.centerX(inView: emailInputView)
        
        view.addSubview(backButton)
        backButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor,
                          paddingTop: 16, paddingRight: 16,
                          width: 36, height:36)
    }
    func configureVerifyPage(){
        
        emailTextField.layer.borderColor = UIColor.butterscotch.cgColor
        emailTextField.isUserInteractionEnabled = true
        editButton.isHidden = true
        
        passwordInputView.removeFromSuperview()
        passwordRequirementView1.removeFromSuperview()
        passwordRequirementView2.removeFromSuperview()
        if view.subviews.contains(self.confirmPasswordInputView){
            confirmPasswordInputView.removeFromSuperview()
        }
        
        actionButton.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: 88).isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.isHidden = false
            self.actionButton.backgroundColor = UIColor.butterscotch
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
    }

    func configureRegisterPage(){
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.isUserInteractionEnabled = false
        editButton.isHidden = false
        
        view.addSubview(passwordInputView)
        passwordInputView.anchor(top: emailInputView.bottomAnchor,
                                 left: emailInputView.leftAnchor,
                                 right: emailInputView.rightAnchor,
                                 paddingTop: 20, height: 72)
        
        let stack = UIStackView(arrangedSubviews: [passwordRequirementView1, passwordRequirementView2])
        stack.spacing = 4
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: passwordInputView.bottomAnchor, left: emailInputView.leftAnchor, paddingTop: 26)
        
        view.addSubview(confirmPasswordInputView)
        confirmPasswordInputView.anchor(top: stack.bottomAnchor,
                                        left: emailInputView.leftAnchor,
                                        right: emailInputView.rightAnchor,
                                        paddingTop: 16, height: 72)
        
        actionButton.topAnchor.constraint(equalTo: confirmPasswordInputView.bottomAnchor, constant: 84).isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.passwordInputView.alpha = 1
            self.confirmPasswordInputView.alpha = 1
            self.passwordRequirementView1.alpha = 1
            self.passwordRequirementView2.alpha = 1
            self.actionButton.backgroundColor = UIColor(white: 238/255, alpha: 1)
            self.actionButton.isHidden = true
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.subtitleLabel.isHidden = true
                self.titleLabel.text = "Set up Your Account"
                self.titleLabel.alpha = 1
                self.actionButton.isHidden = false
                self.actionButton.isUserInteractionEnabled = false
            }
        }
    }
    func configureLoginPage(){
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.isUserInteractionEnabled = false
        editButton.isHidden = false
        
        view.addSubview(passwordInputView)
        passwordInputView.anchor(top: emailInputView.bottomAnchor,
                                 left: emailInputView.leftAnchor,
                                 right: emailInputView.rightAnchor,
                                 paddingTop: 37, height: 72)
        
        actionButton.topAnchor.constraint(equalTo: passwordInputView.bottomAnchor, constant: 76).isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.passwordInputView.alpha = 1
            self.actionButton.backgroundColor = UIColor(white: 238/255, alpha: 1)
            self.actionButton.isHidden = true
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.subtitleLabel.isHidden = true
                self.titleLabel.text = "Log In"
                self.titleLabel.alpha = 1
                self.actionButton.isHidden = false
                self.actionButton.isUserInteractionEnabled = false
            }
        }
    }
}
//MARK: - Email format check
extension AuthController {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,10}"
        let emailRegEx2 = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+\\.[A-Za-z]{1,10}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailPred2 = NSPredicate(format:"SELF MATCHES %@", emailRegEx2)
        return emailPred.evaluate(with: email) || emailPred2.evaluate(with: email)
    }
    func isValidPassword(_ password: String) ->Bool{
        let passwordRegEx = "[A-Z0-9a-z]{6,20}"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
//MARK: - UITextFieldDelegate
extension AuthController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            guard let email = textField.text else { return true}
            let emailIsValid = isValidEmail(email)
            
            if emailIsValid {
                actionButton.backgroundColor = .butterscotch
                actionButton.isUserInteractionEnabled = true
            }else {
                actionButton.backgroundColor = UIColor(white: 238/255, alpha: 1)
            }
            return true
        }else if textField == passwordTextField {
            guard let password = textField.text else { return true }
            if status == .login {
                actionButton.backgroundColor = .butterscotch
                actionButton.isUserInteractionEnabled = true
                return true
                
            }else {
                let passwordIsValid = isValidPassword(password+string)
                if passwordIsValid {
                    passwordRequirementLabel1.textColor = .freshGreen
                    passwordRequirementLabel2.textColor = .freshGreen
                    passwordRequirementImageView1.image = UIImage(named: "icnAvailableXs")
                    passwordRequirementImageView2.image = UIImage(named: "icnAvailableXs")
                    return true
                }else{
                    passwordRequirementLabel1.textColor = .gray
                    passwordRequirementLabel2.textColor = .gray
                    passwordRequirementImageView1.image = UIImage(named: "icnDotXs")
                    passwordRequirementImageView2.image = UIImage(named: "icnDotXs")
                }
                return true
            }
            
        }else if textField == confirmPasswordTextField, let text = textField.text {
            guard let password = passwordTextField.text else { return true }

            if text + string == password {
                actionButton.backgroundColor = .butterscotch
                actionButton.isUserInteractionEnabled = true
            }else {
                actionButton.backgroundColor = UIColor(white: 238/255, alpha: 1)
                actionButton.isUserInteractionEnabled = false
            }
            return true
        }
        return false
    }
}

