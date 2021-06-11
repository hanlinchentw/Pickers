//
//  ActionController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

class ActionViewController: UIViewController {
    //MARK: - Properties
    var state: ListState?
    var selectedRestaurants = [Restaurant]()
    var viewModel: LuckyWheelViewModel? { didSet{ configureWheel() } }
    
    private let resultView: RestaurantCardCell = {
        let result = RestaurantCardCell()
        result.selectButton.isHidden = true
        result.alpha = 0
        return result
    }()
    private var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnSpin")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleStartButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    private let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnNote")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleListButtonTapped), for: .touchUpInside)
        return button
    }()
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        return label
    }()
    private var wheel : LuckyWheel?
    private let bottomSheetVC = BottomSheetViewController()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWheel()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBottomSheetView()
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bottomSheetVC.tableView.restaurants = self.selectedRestaurants
        self.bottomSheetVC.list?.restaurants = self.selectedRestaurants
        if self.selectedRestaurants.isEmpty{
            self.state = .temp
            self.bottomSheetVC.state = .temp
        }
    }
    //MARK: - Helpers
    func configureUI(){
        view.addSubview(listButton)
        listButton.anchor(top: view.topAnchor, right: view.rightAnchor,
                          paddingTop: 52, paddingRight: 20,
                          width: 40, height: 40)
        
    }
    func configureBottomSheetView(){
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.wheel!.frame.maxY + 24, width: width, height: height)
    }
    func configureWheel(){
        wheel = LuckyWheel(frame: CGRect(x: 0, y: 0, width: 330 , height: 330))
        wheel?.delegate = self
        wheel?.dataSource = self
        wheel?.isUserInteractionEnabled = false
        
        self.view.addSubview(wheel!)
        wheel?.center = view.center
        wheel?.frame.origin.y = view.frame.origin.y + 48 + 24
        wheel?.animateLanding = false
        
        view.addSubview(startButton)
        startButton.center(inView: wheel!)
        startButton.setDimension(width: 85, height: 85)
        startButton.layer.cornerRadius = 40 / 2
        startButton.isUserInteractionEnabled = !(viewModel == nil)
        
        self.view.bringSubviewToFront(self.bottomSheetVC.view)
    }
    
    func configureList(list: List?, addRestaurant: Restaurant? = nil){
        if list == nil{
            bottomSheetVC.state = (bottomSheetVC.state == .temp) ? .temp : .edited
            self.state = bottomSheetVC.state
            guard let viewModel = viewModel else { return }
            if self.state == .temp{
                let resID = viewModel.restaurants.map {$0.restaurantID}
                let timestamp = NSDate().timeIntervalSince1970
                let list = List(name: "My selected list", restaurantsID: resID, timestamp: timestamp)
                bottomSheetVC.list = list
                bottomSheetVC.tableView.restaurants = viewModel.restaurants
            }else{
                guard let restaurant = addRestaurant else { return }
                if restaurant.isSelected{
                    bottomSheetVC.list?.restaurantsID.append(restaurant.restaurantID)
                    if let index = bottomSheetVC.tableView.restaurants
                        .firstIndex(where: { $0.restaurantID == restaurant.restaurantID}){
                        bottomSheetVC.tableView.restaurants[index].isSelected.toggle()
                    }else{
                        bottomSheetVC.tableView.restaurants.append(restaurant)
                    }
                }else{
                    guard let newlistID =
                        (bottomSheetVC.list?.restaurantsID.filter({ $0 != restaurant.restaurantID })) else { return }
                    bottomSheetVC.list?.restaurantsID = newlistID
                    bottomSheetVC.tableView.restaurants = bottomSheetVC.tableView.restaurants.filter({ $0.restaurantID != restaurant.restaurantID })
                }
            }
        }else if let list = list{
            self.state = .existed
            self.selectedRestaurants = list.restaurants
            bottomSheetVC.list = list
            bottomSheetVC.tableView.restaurants = list.restaurants
            bottomSheetVC.state = .existed
            let viewModel = LuckyWheelViewModel(restaurants: list.restaurants)
            self.viewModel = viewModel
            
            guard let tab = self.tabBarController as? HomeController else { return }
            tab.deselectAllFromActionViewController(actionVC: self)
            self.selectedRestaurants.forEach{
                try! tab.updateSelectedRestaurants(from: self, restaurant: $0)
                self.updateSelectedRestaurantsInCoredata(context: self.context, restaurant: $0)
            }
        }
    }
    func configureSpiningUI(){
        self.bottomSheetVC.view.isHidden = true
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "hungryGirl")?.withRenderingMode(.alwaysOriginal)
        
        view.addSubview(stateLabel)
        stateLabel.text = "What's for today?"
        stateLabel.centerX(inView: view)
        stateLabel.anchor(top: wheel?.bottomAnchor, paddingTop: 32)
        
        view.addSubview(iv)
        iv.anchor(top: stateLabel.bottomAnchor, paddingTop: 16, width: 200, height: 200)
        iv.centerX(inView: view)
    }
    func configureResultView(valueRelateToResult value: Int){
        guard let restaurant = self.viewModel?.restaurants[value-1] else { return }
        view.addSubview(resultView)
        resultView.centerX(inView: self.view)
        resultView.anchor(top: stateLabel.bottomAnchor, paddingTop: 16, width: 382, height: 279)
        resultView.restaurant = restaurant
        stateLabel.text = "✔︎ \(restaurant.name) for TODAY !"
        self.resultView.alpha = 1
    }
    
    //MARK: - Selectors
    @objc func handleStartButtonTapped(){
        guard let viewModel = self.viewModel else { return }
        guard !viewModel.restaurants.isEmpty else { return}
        self.startButton.changeImageButtonWithBounceAnimation(changeTo: "btnSpin")
        
        let resultNumber = Int.random(in: 1...viewModel.restaurants.count)
        
        self.wheel?.setTarget(section: resultNumber)
        bottomSheetVC.view.isHidden = true
        wheel?.manualRotation(aCircleTime: 0.3)
        configureSpiningUI()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.wheel?.manualRotation(aCircleTime: 0.7)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.wheel?.stop()
            }
        }
    }
    @objc func handleListButtonTapped(){  
        let table = ListTableViewController()
        table.delegate = self
        self.navigationController?.pushViewController(table, animated: true)
    }
}
//MARK: - LuckyWheelDelegate, LuckyWheelDataSource
extension ActionViewController : LuckyWheelDelegate, LuckyWheelDataSource {
    func wheelDidChangeValue(_ newValue: Int) {
        configureResultView(valueRelateToResult: newValue)
    }
    func numberOfSections() -> Int {
        guard let viewModel = self.viewModel, !selectedRestaurants.isEmpty else { return 4 }
        return viewModel.numOfSection
    }
    func itemsForSections() -> [WheelItem] {
        let item1 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .white)
        let item2 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .pale)
        let item3 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .white)
        let item4 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .pale)
        
        guard let viewModel = viewModel, !selectedRestaurants.isEmpty else { return [item1, item2, item3, item4]}
        return viewModel.itemForSection
    }
}
//MARK: -  BottomSheetDelegate
extension ActionViewController{
    func didSelectFromSheet(restaurant: Restaurant){
        if restaurant.isSelected {
            selectedRestaurants.append(restaurant)
        }else {
            selectedRestaurants = selectedRestaurants.filter{($0.restaurantID != restaurant.restaurantID)}
        }
        let viewModel = LuckyWheelViewModel(restaurants: self.selectedRestaurants)
        self.viewModel = viewModel
        
        self.updateSelectedRestaurantsInCoredata(context: self.context, restaurant: restaurant)
        guard let tab = self.tabBarController as? HomeController else { return }
        try! tab.updateSelectedRestaurants(from: self, restaurant: restaurant)
    }
}
//MARK: - ListTableViewControllerDelegate
extension ActionViewController: ListTableViewControllerDelegate{
    func didSelectList(_ controller: ListTableViewController, list: List) {
        configureList(list: list)
        controller.navigationController?.popViewController(animated: true)
    }
    func willPopViewController(_ controller: ListTableViewController){
        let list = self.bottomSheetVC.list
        if let index = controller.lists.firstIndex(where: {$0.id == list?.id}){
            var mutableList = controller.lists[index]
            guard mutableList.isEdited else { controller.navigationController?.popViewController(animated: true)
                    return }
            controller.fetchRestaurants(restaurantsID: mutableList.restaurantsID) { (restaurants) in
                mutableList.restaurants = restaurants
                self.configureList(list: mutableList)
                guard mutableList.restaurantsID.count == restaurants.count else { return }
                controller.navigationController?.popViewController(animated: true)
                return
            }
        }
        controller.navigationController?.popViewController(animated: true)
    }
}
