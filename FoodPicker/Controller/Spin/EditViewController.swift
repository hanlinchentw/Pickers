//
//  EditViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/30.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Combine

private let editIdentifier = "EditCell"

protocol EditViewControllerDelegate: AnyObject{
    func didEditList(_ controller: EditViewController, editList: List?)
}

class EditViewController: UITableViewController{
    //MARK: - Properties
    private var isEdited = false
    var list: List { didSet{ tableView.reloadData() }}
    weak var delegate : EditViewControllerDelegate?
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icnArrowBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 12
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 40)
        return button
    }()
    
    private lazy var listNameTextField: UITextField = {
        let tf = UITextField()
        tf.text = list.name
        tf.font = UIFont(name: "ArialMT", size: 16)
        tf.layer.cornerRadius = 12
        tf.clearButtonMode = .whileEditing
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.masksToBounds = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.returnKeyType = .default
    
        return tf
    }()
    private lazy var lengthOfName: UILabel = {
        let label = UILabel()
        label.text = "\(list.name.count) / 20"
        label.font = UIFont(name: "ArialMT", size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var numOfRestaurantsLabel: UILabel = {
        let label = UILabel()
        let numOfRestaurantLabel = UILabel()
        label.text = "\(list.restaurantsID.count) restaurants"
        label.font = UIFont(name: "ArialMT", size: 14)
        return label
    }()
    private lazy var saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.setDimension(width: 183, height: 48)
        button.addTarget(self, action: #selector(handleSaveAction), for: .touchUpInside)
        return button
    }()
    private lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "ArialMT", size: 16)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 12
        button.setDimension(width: 183, height: 48)
        button.addTarget(self, action: #selector(handleCancelAction), for: .touchUpInside)
        return button
    }()
    private var subscriber = Set<AnyCancellable>()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - Lifecycle
    init(list:List) {
        self.list = list
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
    }

    func saveList(){
        let coreDataService = CoredataConnect(context: context)
        if list.restaurantsID.isEmpty{
            self.presentPopupViewWithButtonAndProvidePublisher(title: "Empty List", subtitle: "Empty List will be DELETED 😲", buttonTitle: "DELETE")
                .sink { [unowned self] _ in
                    coreDataService.deleteList(list: list){
                        self.delegate?.didEditList(self, editList: nil)
                    }failure: { error in
                        print("DEBUG: Failed to delete list")
                    }
                }.store(in: &subscriber)
        }else if (self.listNameTextField.text == nil) || (self.listNameTextField.text == "") {
            self.presentPopupViewWithoutButton(title: "Invalid name", subtitle:  "Please name your list in 20 chars." )
        }else{
            self.list.name = self.listNameTextField.text!
            coreDataService.updateList(list: list)
            self.delegate?.didEditList(self, editList: self.list)
        }
    }
    //MARK: - Selectors
    @objc func handleDismissal(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleSaveAction(){
        self.saveList()
    }
    @objc func handleCancelAction(){
        if isEdited{
            self.presentPopupViewWithButtonAndProvidePublisher(title: "List Edited", subtitle: "Are you sure you want to leave?", buttonTitle: "Leave")
                .sink { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }.store(in: &subscriber)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
//MARK: - UITableViewDelegate/ DataSoruce
extension EditViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.restaurants.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: editIdentifier, for: indexPath)
        as! RestaurantListCell
        let viewModel = CardCellViewModel(restaurant: list.restaurants[indexPath.row])
        cell.viewModel = viewModel
        cell.config = .edit
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(listNameTextField)
        listNameTextField.setDimension(width: self.view.frame.width*0.8, height: 40)
        listNameTextField.centerX(inView: view)
        listNameTextField.anchor(top: view.topAnchor, paddingTop: 16)
        
        view.addSubview(lengthOfName)
        lengthOfName.anchor(top: listNameTextField.bottomAnchor, right: view.rightAnchor,
                            paddingTop: 4, paddingRight: 16)
       
        view.addSubview(numOfRestaurantsLabel)
        numOfRestaurantsLabel.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                                    paddingLeft: 16, paddingBottom: 8)
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        128
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let stack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillProportionally
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.bottomAnchor)
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
}
//MARK: - UITextFieldDelegate
extension EditViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.isEdited = true
        var tempString = ""
        if let text = textField.text { tempString += text}
        tempString += string
        let newLength = tempString.count - range.length
        if newLength > 20{
            return false
        }else{
            lengthOfName.text = "\(newLength) / 20"
            return true
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        lengthOfName.text = "0 / 20"
        return true
    }
}
//MARK: -RestaurantListCellDelegate
extension EditViewController: RestaurantListCellDelegate{
    func deleteFavoriteRestaurant(_ restaurant: Restaurant) {
        guard let index = self.list.restaurants.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }) else { return }
        tableView.beginUpdates()
        self.list.restaurants.remove(at: index)
        UIView.animate(withDuration: 0.1) {
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
        tableView.endUpdates()
        self.numOfRestaurantsLabel.text = "\(self.list.restaurantsID.count) restaurants"
        self.isEdited = true
    }
}
//MARK: - Autolayout and configure table view method
extension EditViewController {
    func configureUI(){
        view.backgroundColor = .backgroundColor
        listNameTextField.delegate = self
        navigationItem.title = "Edit List"

        let backButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 40))
        backButtonView.bounds = backButtonView.bounds.offsetBy(dx: 18, dy: 0)
        backButtonView.addSubview(backButton)
        let leftBarItem = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 93+24
        tableView.separatorStyle = .none
        tableView.register(RestaurantListCell.self, forCellReuseIdentifier: editIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
