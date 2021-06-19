//
//  ProfileController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Firebase

private let profileCellIndentifier = "profileRowCell"

protocol ProfileControllerDelegate: AnyObject {
    func logOutButtonTapped()
}

class ProfileController: UITableViewController {
    //MARK: - Properties
    var email : String
    weak var delegate : ProfileControllerDelegate?
    //MARK: - Controller Lifecycle
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .backgroundColor
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    //MARK: - Firebase API
    @objc func logUserOut(){
        do {
            try Auth.auth().signOut()
            delegate?.logOutButtonTapped()
        }
        catch{ print("DEBUG: Failed to sign out with error ...\(error.localizedDescription)") }
    }
    //MARK: -  UI Configure Method
    private func configureTableView(){
        tableView.rowHeight = 56
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: profileCellIndentifier)
    }
    
    private func configureUI(){
        navigationController?.navigationBar.isHidden = true
        self.view.layoutIfNeeded()
    }
}
//MARK: -  ProfileControllerDelegate & DataSource
extension ProfileController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profileCellIndentifier) as! UITableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.imageView?.image = UIImage(named: "icon24Lock")?.withRenderingMode(.alwaysOriginal)
        cell.textLabel?.text = "Reset Password"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 80 / 2
        iv.image = UIImage(named: "icon56PickerLogo")?
            .withRenderingMode(.alwaysOriginal)
        
        let emailLabel = UILabel()
        emailLabel.font = UIFont(name: "Arial-MT", size: 16)
        emailLabel.text = email
        
        view.addSubview(emailLabel)
        emailLabel.centerX(inView: view)
        emailLabel.anchor(bottom: view.bottomAnchor, paddingBottom: 24)
        
        view.addSubview(iv)
        iv.centerX(inView: view)
        iv.anchor(bottom: emailLabel.topAnchor, paddingBottom: 16, width: 80, height: 80)
        
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let inset = UIApplication.shared.windows[0].safeAreaInsets.top
        return 256 - inset
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .backgroundColor

        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.backgroundColor = .butterscotch
        textLabel.textColor = .white
        textLabel.text = "Log Out"
        textLabel.font = UIFont(name: "Arial-BoldMT", size: 16)
        
        textLabel.layer.masksToBounds = true
        textLabel.layer.cornerRadius = 24

        view.addSubview(textLabel)
        textLabel.setDimension(width: 108, height: 48)
        textLabel.center(inView: view)
        
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(logUserOut) )
        
        textLabel.isUserInteractionEnabled = true
        textLabel.addGestureRecognizer(logoutTap)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300
    }
}
