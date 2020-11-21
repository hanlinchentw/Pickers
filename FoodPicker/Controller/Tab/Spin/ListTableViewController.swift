//
//  ListTableViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/18.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let listCellIdentifier = "ListTableCell"

protocol ListTableViewControllerDelegate: class {
    func willPopViewController(_ controller: ListTableViewController)
    func didSelectList(_ controller: ListTableViewController, list: List)
}

class ListTableViewController: UITableViewController{
    //MARK: - Properties
    var lists = [List]() { didSet{ self.tableView.reloadData() }}
    weak var delegate: ListTableViewControllerDelegate?
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        fetchSavedLists()
    }
    //MARK: - Helpers
    func configureNavBar(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = false
        navBar.shadowImage = UIImage()
        navBar.barTintColor = .backgroundColor
        navBar.isTranslucent = true
        navigationItem.title = "Saved Lists"
        
        let backButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 40))
        backButtonView.bounds = backButtonView.bounds.offsetBy(dx: 18, dy: 0)
        backButtonView.addSubview(backButton)
        let leftBarItem = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    func configureTableView(){
        tableView.backgroundColor = .backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 116
        tableView.separatorStyle = .none
        tableView.register(ListInfoCell.self, forCellReuseIdentifier: listCellIdentifier)
    }
    //MARK: - API
    func fetchSavedLists(){
        RestaurantService.shared.fetchSavedLists { (lists) in
            self.lists = lists
        }
    }
    func fetchRestaurants(restaurantsID: [String], completion: @escaping([Restaurant])->Void){
        var restaurants = [Restaurant]()
        restaurantsID.forEach { (id) in
            NetworkService.shared.fetchDetail(id: id) { (detail) in
                var restaurant = Restaurant(business: nil, detail: detail)
                restaurant.isSelected = true
                restaurants.append(restaurant)
                completion(restaurants)
            }
        }
    }
    //MARK: - Selectors
    @objc func handleDismissal(){
        delegate?.willPopViewController(self)
    }
}
extension ListTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return lists.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listCellIdentifier, for: indexPath)
            as! ListInfoCell
        cell.selectionStyle = .none
        cell.list = self.lists[indexPath.section]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectList = self.lists[indexPath.section]
        fetchRestaurants(restaurantsID: selectList.restaurantsID) { (restaurants) in
            selectList.restaurants = restaurants
            guard restaurants.count == selectList.restaurantsID.count else { return }
            self.delegate?.didSelectList(self, list: selectList)
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }
}
