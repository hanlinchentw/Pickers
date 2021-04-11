//
//  FavoriteController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

private let favoriteIdentifier = "FavoriteCell"

class FavoriteController: UIViewController {
    //MARK: - Properties
    var isEditingMode = false { didSet{ self.tableView.reloadData()}}
    var likedRestaurants = [Restaurant]()
    var mutableSource = [Restaurant]() { didSet{ self.tableView.reloadData() }}
    
    private let tableView = UITableView()
    
    private let navBarView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 36
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "My Favorite"
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.centerY(inView: view, yConstant: 24)
        return view
    }()
    
    private lazy var editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setImage(UIImage(named: "icnEditSmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.semanticContentAttribute =  .forceRightToLeft
        button.backgroundColor = .backgroundColor
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditButtonTapped), for: .touchUpInside)
        return button
    }()
    private let searchBarTextField = UITextField().createSearchBar(withPlaceholder: "Search in my favorite")
    private let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLikedRestauants()
    }
    //MARK: - API
    func fetchLikedRestauants(){
        let connect = CoredataConnect(context: context)
        connect.fetchLikedRestaurant { (restaurants) in
            self.mutableSource = restaurants
            self.likedRestaurants = restaurants
            self.checkBeforeRestaurantLoaded()
        }
        //        RestaurantService.shared.fetchLikedRestaurants { (restaurants) in
        //            self.mutableSource = restaurants
        //            self.likedRestaurants = restaurants
        //        }
    }
    func checkBeforeRestaurantLoaded(){
        for (index, item) in likedRestaurants.enumerated(){
            let connect = CoredataConnect(context: context)
            connect.checkIfRestaurantIsIn(entity: selectedEntityName, id: item.restaurantID) { (isSelected) in
                guard isSelected else { return }
                self.likedRestaurants[index].isSelected = true
                self.mutableSource[index].isSelected = true
            }
        }
    }
    func updateSelectedRestaurant(restaurant: Restaurant){
        guard let tab = self.tabBarController as? HomeController else { return }
        do{
            try tab.updateSelectedRestaurants(from: self, restaurant: restaurant)
            self.updateSelectedRestaurantsInCoredata(restaurant: restaurant)
        }catch SelectRestaurantResult.upToLimit{
            let alert = UIAlertController(title: "Sorry! you can only select 8 restaurant. 😢", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                self.fetchLikedRestauants()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }catch{
            print("DEBUG: Failed to select restaurant.")
        }
    }
    //MARK: - CoreData
    private func updateSelectedRestaurantsInCoredata(restaurant: Restaurant){
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: selectedEntityName, id: restaurant.restaurantID) { (isSelected) in
            if isSelected{
                connect.deleteRestaurantIn(entityName: selectedEntityName, id: restaurant.restaurantID)
            }else{
                connect.saveRestaurantInLocal(restaurant: restaurant, entityName: selectedEntityName,
                                              trueForSelectFalseForLike: true)
            }
        }
    }
    func updateLikedRestaurantsInDataBase(restaurant:Restaurant){
        RestaurantService.shared.updateLikedRestaurant(restaurant: restaurant, shouldLike: !restaurant.isLiked)
        let connect = CoredataConnect(context: context)
        connect.checkIfRestaurantIsIn(entity: likedEntityName, id: restaurant.restaurantID) { (isLiked) in
            if isLiked{
                connect.deleteRestaurantIn(entityName: likedEntityName, id: restaurant.restaurantID)
            }else{
                connect.saveRestaurantInLocal(restaurant: restaurant, entityName: likedEntityName,
                                              trueForSelectFalseForLike: false)
            }
        }
    }
    //MARK: - Helpers
    func configureNavBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        view.addSubview(navBarView)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        navBarView.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          height: 104)
    }
    func configureUI(){
        searchBarTextField.delegate = self
        view.addSubview(searchBarTextField)
        searchBarTextField.anchor(top: navBarView.bottomAnchor, left: view.leftAnchor,
                                  right: view.rightAnchor, paddingTop: 16,
                                  paddingLeft: 16, paddingRight: 16, height: 40)
        searchBarTextField.centerX(inView: view)
        
        view.addSubview(editButton)
        editButton.anchor(top: searchBarTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16)
    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.rowHeight = 88 + 16
        view.addSubview(tableView)
        tableView.anchor(top: navBarView.bottomAnchor, left: view.leftAnchor,
                         right: view.rightAnchor, bottom: view.bottomAnchor, paddingBottom: 16)
        tableView.register(RestaurantListCell.self, forCellReuseIdentifier: favoriteIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 40+16+56-8, left: 0, bottom: 0, right: 0)
    }
    //MARK: - Selectors
    @objc func handleEditButtonTapped(){
        print("DEBUG: edit...")
        self.isEditingMode.toggle()
        self.editButton.alpha = 0
        UIView.animate(withDuration: 1) {
            let buttonImageName : String =  self.isEditingMode ? "icnSuccessS":"icnEditSmall"
            self.editButton.setImage(UIImage(named: buttonImageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            let buttonTitle = self.isEditingMode ? "Finish" : "Edit"
            self.editButton.setTitle(buttonTitle, for: .normal)
            
            let tintColor : UIColor = self.isEditingMode ? UIColor.freshGreen : UIColor.black
            self.editButton.setTitleColor( tintColor, for: .normal)
        } completion: { (_) in
            UIView.animate(withDuration: 1) {
                self.editButton.alpha = 1
            }
        }
    }
}
extension FavoriteController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mutableSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteIdentifier, for: indexPath)
            as! RestaurantListCell
        let viewModel = CardCellViewModel(restaurant: self.mutableSource[indexPath.row])
        cell.viewModel = viewModel
        cell.backgroundColor = .backgroundColor
        cell.delegate = self
        cell.config = isEditingMode ? .edit : .table
        cell.selectionStyle = .none
        return cell
    }
}
extension FavoriteController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text?.lowercased() else { return true }
        if string == "" , text.count == 1{
            mutableSource = likedRestaurants
        }else if string == "" {
            let pred = NSPredicate(format: "SELF CONTAINS %@", String(text.dropLast()))
            self.mutableSource = likedRestaurants.filter { pred.evaluate(with: $0.name.lowercased()) }
        }else {
            let pred = NSPredicate(format: "SELF CONTAINS %@", text + string.lowercased())
            self.mutableSource = likedRestaurants.filter { pred.evaluate(with: $0.name.lowercased()) }
        }
        return true
    }
}

extension FavoriteController: RestaurantListCellDelegate {
    func didSelectRestaurant(_ restaurant:Restaurant) {
        guard let index = self.likedRestaurants.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }) else { return }
        self.likedRestaurants[index].isSelected.toggle()
        
        self.updateSelectedRestaurant(restaurant: restaurant)
    }
    func shouldDeleteCell(_ restaurant: Restaurant) {
        guard let index = self.mutableSource.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }) else { return }
        guard let index2 = self.likedRestaurants.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }) else { return }
        tableView.beginUpdates()
        UIView.animate(withDuration: 0.1) {
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
        self.mutableSource.remove(at: index)
        self.likedRestaurants.remove(at: index2)
        tableView.endUpdates()
        self.updateLikedRestaurantsInDataBase(restaurant: restaurant)
    }
}
