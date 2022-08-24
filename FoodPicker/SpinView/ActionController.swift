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
//    var viewModel: LuckyWheelViewModel? { didSet{ configureWheel() } }
    
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
    private var resultView = SpinResultView()
    private var wheel : LuckyWheel?
    private let bottomSheetVC = BottomSheetViewController()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWheel()
        configureListButton()
        configureResultView()
//        observeEntityChange()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBottomSheetView()
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = true
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.bottomSheetVC.tableView.restaurants = self.selectedRestaurants
//        self.bottomSheetVC.list?.restaurants = self.selectedRestaurants
        if self.selectedRestaurants.isEmpty{
            self.state = .temp
            self.bottomSheetVC.state = .temp
        }
    }
    //MARK: - Selectors
    @objc func handleStartButtonTapped(){
//        guard let viewModel = self.viewModel else { return }
//        guard !viewModel.restaurants.isEmpty else { return}
//        self.startButton.changeImageButtonWithBounceAnimation(changeTo: "btnSpin")
//        self.configureWheel()
//        let resultNumber = Int.random(in: 1...viewModel.restaurants.count)
//        wheelSpin(targetIndex: resultNumber)
//        bottomSheetVC.fold()
//        self.resultView.alpha = 1
    }
    func wheelSpin(targetIndex: Int){
        self.wheel?.setTarget(section: targetIndex)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.wheel?.manualRotation(aCircleTime: 0.3)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
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
        self.configureResult(valueRelateToResult: newValue)
    }
    func numberOfSections() -> Int {
//        guard let viewModel = self.viewModel, !selectedRestaurants.isEmpty else { return 4 }
//        return viewModel.numOfSection
      return 4
    }
    func itemsForSections() -> [WheelItem] {
        let item1 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .white)
        let item2 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .pale)
        let item3 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .white)
        let item4 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .pale)
      return [item1, item2, item3, item4]
//        guard let viewModel = viewModel, !selectedRestaurants.isEmpty else { return [item1, item2, item3, item4]}
//        return viewModel.itemForSection
    }
}
//MARK: - Observe entityChange
extension ActionViewController {
    @objc func contextDidChange(_ notification: NSNotification){
//        guard let userInfo = notification.userInfo else { return }
//        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
//           inserts.count > 0 {
//            let insertedObject = inserts.first
//            if let selected = insertedObject as? SelectedRestaurant{
//                var restaurant = self.transfromSelectedRestaurantIntoRestaurant(selectedRestaurant: selected)
//                restaurant.isSelected = true
//                self.selectedRestaurants.append(restaurant)
//                let vm = LuckyWheelViewModel(restaurants: self.selectedRestaurants)
//                self.viewModel = vm
//                if state == .temp || state == nil{
//                    bottomSheetVC.state = .temp
//                    self.state = .temp
////                    configureList(list: nil)
//                }else if state == .existed || state == .edited{
////                    configureList(list: nil, addRestaurant: restaurant)
//                }
//            }
        }
//        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> ,
//           deletes.count > 0 {
//            let deleteObject = deletes.first
//            if let selected = deleteObject as? SelectedRestaurant , let id = selected.id,
//               let index = self.selectedRestaurants.firstIndex(where: { $0.id == id}){
//                var restaurant = self.selectedRestaurants[index]
////                restaurant.isSelected = false
//                self.selectedRestaurants.remove(at: index)
//                let vm = LuckyWheelViewModel(restaurants: self.selectedRestaurants)
//                self.viewModel = vm
//                if state == .temp || state == nil{
////                    configureList(list: nil)
//                }else if state == .existed || state == .edited{
////                    configureList(list: nil, addRestaurant: restaurant)
//                }
//            }
//        }
//    }
}
//MARK: - list method
extension ActionViewController {
//    func configureList(list: List?, addRestaurant: Restaurant? = nil){
//        let restaurants = viewModel?.restaurants ?? []
//        let currentState : ListState = (self.state == .temp) ? .temp : .edited
//        self.state = currentState
//        self.bottomSheetVC.configureList(list: list,
//                                         restaurants: restaurants,
//                                         addRestaurant: addRestaurant)
//        if list != nil { self.state = .existed  }
//    }
    private func ReplaceAllSelectedRestaurantsWithExistedList(list: _List){
//        self.deselectAll()
//        list.restaurants.forEach{
//            self.updateSelectedRestaurantsInCoredata(context: self.context, restaurant: $0)
//        }
//        self.configureList(list: list)
    }
}
//MARK: -  BottomSheetDelegate
extension ActionViewController: BottomSheetViewControllerDelegate{
    func shouldHideResultView(shouldHide: Bool) {
        if shouldHide {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.resultView.alpha = 0
            }
        }else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.resultView.alpha = 1
            }
        }
    }
//    func didSelectFromSheet(restaurant: Restaurant){
//        self.updateSelectedRestaurantsInCoredata(context: self.context, restaurant: restaurant)
//    }
}
//MARK: - ListTableViewControllerDelegate
extension ActionViewController: ListTableViewControllerDelegate{
    func didSelectList(_ controller: ListTableViewController, list: _List) {
        ReplaceAllSelectedRestaurantsWithExistedList(list: list)
        controller.navigationController?.popViewController(animated: true)
    }
    func willPopViewController(_ controller: ListTableViewController){
//        let list = self.bottomSheetVC.list
//        if let index = controller.lists.firstIndex(where: {$0.id == list?.id }){
//            let mutableList = controller.lists[index]
//            guard mutableList.isEdited  else { controller.navigationController?.popViewController(animated: true)
//                return }
//            self.configureList(list: mutableList)
//        }else {
//            self.state = .temp
//            self.bottomSheetVC.state = .temp
//            self.configureList(list: nil, addRestaurant: nil)
//        }
//        controller.navigationController?.popViewController(animated: true)
    }
}
//MARK: -  ResultViewDelegate
extension ActionViewController: SpinResultViewDelegate {
//    func pushToDetailVC(restaurant: Restaurant) {
//        let detailVC = DetailController(restaurant: restaurant)
//        self.showLoadingAnimation()
//        self.retry(3) { success, failure in
//            detailVC.fetchDetail(success: success, failure: failure)
//        } success: {
//            detailVC.delegate = self
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
//                self.navigationController?.navigationBar.barStyle = .black
//                self.navigationController?.pushViewController(detailVC, animated: true)
//                detailVC.configureUIForResult()
//                self.hideLoadingAnimation()
//            }
//        } failure: { _ in
//            self.presentPopupViewWithoutButton(title: "Sorry..",
//                                               subtitle: "Please check you internet connection")
//            self.hideLoadingAnimation()
//        }
//    }
}
//MARK: - DetailControllerDelegate
extension ActionViewController {
//    func didSelectRestaurant(restaurant: Restaurant) {
//
//    }
//
//    func didLikeRestaurant(restaurant: Restaurant) {
//
//    }
    
    func willPopViewController(_ controller: DetailController) {
        controller.navigationController?.popViewController(animated: true)
    }
}
//MARK: - Auto layout
extension ActionViewController {
    func configureWheel(){
        wheel?.removeFromSuperview()
        wheel = LuckyWheel(frame: CGRect(x: 0, y: 0,
                                         width: self.view.wheelHeightAndWidth, height: self.view.wheelHeightAndWidth))
        wheel?.delegate = self
        wheel?.dataSource = self
        wheel?.isUserInteractionEnabled = false
        wheel?.animateLanding = true
        
        self.view.addSubview(wheel!)
        wheel?.center = view.center
        wheel?.frame.origin.y = view.frame.origin.y + 72 * view.widthMultiplier

        view.addSubview(startButton)
        startButton.center(inView: wheel!)
        startButton.setDimension(width: 85, height: 85)
        startButton.layer.cornerRadius = 40 / 2
//        startButton.isUserInteractionEnabled = !(viewModel == nil)
        self.view.bringSubviewToFront(self.bottomSheetVC.view)
    }
    func configureListButton(){
        view.addSubview(listButton)
        listButton.anchor(top: view.topAnchor, right: view.rightAnchor,
                          paddingTop: 52, paddingRight: 20,
                          width: 40, height: 40)
        
    }
    func configureBottomSheetView(){
        self.addChild(bottomSheetVC)
        bottomSheetVC.delegate = self
        self.view.addSubview(bottomSheetVC.view)
        let height = view.frame.height
        let width  = view.frame.width
        let offset = 72 * view.widthMultiplier + view.wheelHeightAndWidth + 24
        
        bottomSheetVC.view.frame = CGRect(x: 0, y: offset, width: width, height: height)
    }
    func configureResultView(){
        resultView.alpha = 0
        let resultViewWidth = self.view.restaurantCardCGSize.width * 1.3
        let resultViewHeight = self.view.restaurantCardCGSize.height * 1.2
        
        view.addSubview(resultView)
        resultView.centerX(inView: self.view)
        let offset = 72 * view.widthMultiplier + view.wheelHeightAndWidth + 24
        resultView.anchor(top: self.view.topAnchor, paddingTop: offset)
        resultView.setDimension(width: resultViewWidth, height: resultViewHeight)
    }
    func configureResult(valueRelateToResult value: Int){
//        guard let restaurant = self.viewModel?.restaurants[value-1] else { return }
//        self.resultView.restaurant = restaurant
//        self.resultView.delegate =  self
    }
}
