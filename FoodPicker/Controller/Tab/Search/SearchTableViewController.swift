//
//  SearchTableViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/23.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
protocol SearchTableViewControllerDelegate: class {
    func didTapBackButton()
    func didSearchbyTerm(term: String)
}
private let searchCellIdentifier = "searchCell"

class SearchTableViewController : UITableViewController{
    //MARK: - Properties
    weak var delegate : SearchTableViewControllerDelegate?
    var historicalRecords = [String]() { didSet{ self.tableView.reloadData()}}
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimension(width: 32, height: 32)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let searchBarTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.textColor = .black
        tf.tintColor = .darkGray
        tf.layer.cornerRadius = 12
        tf.layer.masksToBounds = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .search
        tf.enablesReturnKeyAutomatically = true
        tf.keyboardType = .asciiCapable
        return tf
    }()
    private lazy var searchBarContainerView : UIView = {
        let view = UIView()
        let stack = UIStackView(arrangedSubviews: [backButton, searchBarTextField])
        stack.spacing = 8
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor,
                                  paddingLeft: 16, paddingRight: 16, height: 40)
        stack.centerY(inView: view)
        return view
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    //MARK: - Helpers
    func configureTableView(){
        searchBarTextField.delegate = self
        tableView.backgroundColor = .backgroundColor
        tableView.rowHeight = 40
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: searchCellIdentifier)
    }
    func closeTheKeyBoardAndCleanTextField() {
        searchBarTextField.text?.removeAll()
        searchBarTextField.becomeFirstResponder()
    }
    //MARK: -Selectors
    @objc func handleBackButtonTapped(){
        searchBarTextField.resignFirstResponder()
        delegate?.didTapBackButton()
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

//MARK: - UITableViewDelegate / DataSource
extension SearchTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "History"
        default:
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return historicalRecords.count
        default: return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier, for: indexPath)
        as! SearchCell
        cell.selectionStyle = .none
        if indexPath.section == 1{
            cell.term = historicalRecords[indexPath.row]
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? searchBarContainerView : nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 40 + 24*2 : 20
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let term = historicalRecords[indexPath.row]
            searchBarTextField.text = term
        }
    }
}
//MARK: - UITextFieldDelegate
extension SearchTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let term = searchBarTextField.text else { return false }
        searchBarTextField.resignFirstResponder()
        delegate?.didSearchbyTerm(term: term)
        return true
    }
}

