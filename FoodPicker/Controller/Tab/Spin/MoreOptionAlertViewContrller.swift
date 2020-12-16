//
//  MoreOptionAlertViewContrller.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/23.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol MoreOptionAlertViewContrllerDelegate:class {
    func deleteList(listID:String)
    func editList(list: List)
}

class MoreOptionAlertViewContrller: UIViewController {
    //MARK: - Properties
    var list: List
    weak var delegate: MoreOptionAlertViewContrllerDelegate?
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnCancelGreySmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimension(width: 32, height: 32)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    private lazy var editButton : UIButton = {
        let button = self.createOptionButton(title: "Edit List", imageName: "icnEditSmall")
        button.addTarget(self, action: #selector(handleEditList), for: .touchUpInside)
        return button
    }()
    private lazy var shareButton : UIButton = {
        let button = self.createOptionButton(title: "Share List", imageName: "icnShareSmall")
        return button
    }()
    private lazy var deleteButton : UIButton = {
        let button = self.createOptionButton(title: "Delete List", imageName: "icnDeleteSmall")
        button.setTitleColor(UIColor.errorRed, for: .normal)
        button.addTarget(self, action: #selector(handleDeleteList), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    init(list: List) {
        self.list = list
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configure()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: - Helpers
    func configureView(){
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    func configure(){
        let containerView = UIView()
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.setDimension(width: 224, height: 268)
        containerView.center(inView: self.view)
        
        containerView.addSubview(cancelButton)
        cancelButton.anchor(top:containerView.topAnchor, right: containerView.rightAnchor,
                            paddingTop: 4, paddingRight: 4)
        
        let buttonStack = UIStackView(arrangedSubviews: [editButton, shareButton, deleteButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 16
        buttonStack.distribution = .fillEqually
        
        containerView.addSubview(buttonStack)
        buttonStack.center(inView: containerView)
    }
    func createOptionButton(title:String, imageName:String) -> UIButton{
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "ArialMT", size: 16)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        button.layer.cornerRadius = 48 / 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.75
        button.setDimension(width: 192, height: 48)
        return button
    }
    //MARK: - Selectors
    @objc func handleDismissal(){
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    @objc func handleDeleteList(){
        guard let listID = self.list.id else { return }
        delegate?.deleteList(listID: listID)
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    @objc func handleEditList(){
        delegate?.editList(list: self.list)
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
}
