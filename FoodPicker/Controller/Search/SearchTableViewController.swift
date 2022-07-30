//
//  SearchTableViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/23.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

protocol SearchTableViewControllerDelegate: AnyObject {
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
        tf.layer.cornerRadius = 12
        tf.layer.masksToBounds = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .search
        tf.keyboardType = .asciiCapable
        return tf
    }()
    private lazy var searchBarContainerView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, searchBarTextField])
        stack.spacing = 8
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: 20)
        return stack
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
    func cleanSearchBarAndShowTheKeyboard() {
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
        if section == 1{
            return "History"
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? historicalRecords.count : 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier, for: indexPath)
        as! SearchCell
        cell.selectionStyle = .none
        if indexPath.section == 1{ cell.term = historicalRecords[indexPath.row] }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
             return nil
        }
        return searchBarContainerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let term = historicalRecords[indexPath.row]
        searchBarTextField.text = term
    }
}
//MARK: - UITextFieldDelegate
extension SearchTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let term = searchBarTextField.text else { return false }
        delegate?.didSearchbyTerm(term: term)
        self.cleanSearchBarAndShowTheKeyboard()
        return true
    }
}

