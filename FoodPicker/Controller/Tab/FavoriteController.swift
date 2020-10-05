//
//  FavoriteController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let favoriteIdentifier = "FavoriteCell"

class FavoriteController: UIViewController {
    //MARK: - Properties
    var likedRestaurants = [Restaurant]()
    private let tableView = UITableView()
    var mutableSource = [Restaurant]() { didSet{ self.tableView.reloadData() }}
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
    private let searchBarTextField = UITextField().createSearchBar(withPlaceholder: "Search in my favorite")
    private let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        
        configureTableView()
        configureUI()
        fetchLikedRestauants()
    }
    //MARK: - API
    func fetchLikedRestauants(){
        RestaurantService.shared.fetchLikedRestaurants { (restaurants) in
            self.mutableSource = restaurants
            self.likedRestaurants = restaurants
        }
    }
//    func fetchRestaurantFromDB(){
//        do {
//            likedRestaurants = try context.fetch(LikedRestaurant.fetchRequest())
//        }catch{
//            print("DEBUG: Failed to load favorite list ... \(error.localizedDescription)")
//        }
//    }
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DID_SELECT_KEY),
                                        object: nil,
                                        userInfo: ["Restaurant": restaurant as Restaurant])
    }
}
