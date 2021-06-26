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

class ListTableViewController: UITableViewController, MBProgressHUDProtocol{
    //MARK: - Properties
    var lists = [List]() { didSet{ self.tableView.reloadData() }}
    var expandListIndex = [Int]() { didSet{ self.tableView.reloadData() }}
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
        tableView.separatorStyle = .none
        tableView.register(ListInfoCell.self, forCellReuseIdentifier: listCellIdentifier)
    }
    //MARK: - API
    func fetchSavedLists(completion: (()-> Void)? = nil){
        self.showLoadingAnimation()
        RestaurantService.shared.fetchSavedLists { (lists) in
            self.hideLoadingAnimation()
            self.lists = lists
            if let completion = completion{
                completion()
            }
        }
    }
    func fetchRestaurants(restaurantsID: [String], completion: @escaping([Restaurant])->Void){
        var restaurants = [Restaurant]()
        restaurantsID.forEach { (id) in
            NetworkService.shared.fetchDetail(id: id) { (detail, error) in
                var restaurant = Restaurant(business: nil, detail: detail)
                restaurant.isSelected = true
                restaurants.append(restaurant)
                completion(restaurants)
            }
        }
    }
    func checkIfListEdited(listID: String){
        RestaurantService.shared.updateListAfterEditing(listID: listID) { list in
            if let list = list, let index = self.lists.firstIndex(where: {$0.id == listID}){
                self.lists[index] = list
            }else{
                self.lists = self.lists.filter { $0.id != listID }
            }
            self.tableView.reloadData()
        }
    }
    //MARK: - Selectors
    @objc func handleDismissal(){
        delegate?.willPopViewController(self)
    }
}
//MARK: - TableViewDelegate/Datasource
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
        cell.delegate = self
        cell.list = self.lists[indexPath.section]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectList = self.lists[indexPath.section]
        self.view.isUserInteractionEnabled = false
        self.fetchRestaurants(restaurantsID: selectList.restaurantsID) { (restaurants) in
            selectList.restaurants = restaurants
            guard restaurants.count == selectList.restaurantsID.count else { return }
            self.delegate?.didSelectList(self, list: selectList)
            self.view.isUserInteractionEnabled = true
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandListIndex.contains(indexPath.section){
            return CGFloat(lists[indexPath.section].restaurantsID.count * 117) + 116
        }else{
            return 116
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
//MARK: - ListInfoCellDelagete
extension ListTableViewController: ListInfoCellDelagete{
    func shouldExpandList(_ cell: ListInfoCell, _ shouldExpand: Bool, list: List) {
        if let index = self.lists.firstIndex(where: { $0.id == list.id }) {
            print(index)
            if shouldExpand{
                self.showLoadingAnimation()
                if list.restaurants.isEmpty{
                    self.fetchRestaurants(restaurantsID: list.restaurantsID) { (restaurants) in
                        guard list.restaurantsID.count == restaurants.count else { return }
                        cell.list?.restaurants = restaurants
                        cell.configureTableView()
                        self.hideLoadingAnimation()
                    }
                }
                self.expandListIndex.append(index)
            }else{
                if let foldIndex = self.expandListIndex.firstIndex(where: {$0 == index}) {
                    self.expandListIndex.remove(at: foldIndex)
                }
            }
        }
    }
    func didTapMoreButton(list: List) {
        let alert = MoreOptionAlertViewContrller(list: list)
        alert.delegate = self
        let nav = UINavigationController(rootViewController: alert)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false, completion: nil)
    }
}
//MARK: - MoreOptionAlertViewContrllerDelegate
extension ListTableViewController: MoreOptionAlertViewContrllerDelegate{
    func deleteList(listID: String){
        RestaurantService.shared.deleteList(listID: listID)
        guard let index = self.lists.firstIndex(where: {$0.id == listID}) else { return }
        self.lists.remove(at: index)
    }
    func editList(list: List) {
        self.fetchRestaurants(restaurantsID: list.restaurantsID) { (restaurants) in
            let edit = EditViewController(list: list)
            edit.list.restaurants = restaurants
            edit.delegate = self
            guard list.restaurantsID.count == restaurants.count else { return }
            self.navigationController?.pushViewController(edit, animated: true)
        }
    }
}
//MARK: - EditViewControllerDelegate
extension ListTableViewController: EditViewControllerDelegate{
    func didEditList(_ controller:EditViewController) {
        guard let id = controller.list.id else { return }
        checkIfListEdited(listID: id)
        controller.navigationController?.popViewController(animated: true)
        createSuccessfullySavedMessage()
    }
    fileprivate func createSuccessfullySavedMessage(){
        let label = UILabel()
        label.text = "Successfully saved!"
        label.font = UIFont(name: "Arial-BoldMT", size: 14)
        label.backgroundColor = UIColor(red: 228/255, green: 255/255, blue: 215/255, alpha: 1)
        label.textColor = .freshGreen
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.alpha = 0
        let size = label.intrinsicContentSize
        let height = size.height + 8
        let width = size.width + 32
        label.setDimension(width: width, height: height)
        view.addSubview(label)
        label.anchor(top: view.topAnchor)
        label.centerX(inView: view)
        
        UIView.animate(withDuration: 2, animations: {
            label.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 2) {
                label.alpha = 0
            }
        }
    }
}
