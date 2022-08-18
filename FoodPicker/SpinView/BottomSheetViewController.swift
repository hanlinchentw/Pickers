//
//  BottomSheetViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/8/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Combine

private let selectedIdentifier = "RestaurantListCell"

enum ListState{
    case temp
    case existed
    case edited
}

protocol BottomSheetViewControllerDelegate: AnyObject {
//    func shouldHideResultView(shouldHide: Bool)
//    func didSelectFromSheet(restaurant: Restaurant)
}
class BottomSheetViewController : UIViewController {
    //MARK: - Properties
    var list: _List?
    var state: ListState = .temp { didSet{ didChangeState() }}
    weak var delegate: BottomSheetViewControllerDelegate?
    private let notchView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightlightGray
        view.setDimension(width: 60, height: 4)
        view.layer.cornerRadius = 4 / 2
        return view
    }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.text = "My selected list"
        label.textColor = .black
        return label
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton(type:.system)
        button.backgroundColor = .butterscotch
        button.setTitle("Save list", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 14)
        button.setDimension(width: 103 , height: 32)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
        return button
    }()
    private let updateButton: UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("Update", for: .normal)
        button.setTitleColor(.butterscotch, for: .normal)
        button.layer.borderColor = UIColor.butterscotch.cgColor
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 0.75
        button.isHidden = true
        button.setDimension(width: 81 , height: 32)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleUpdateButtonTapped), for: .touchUpInside)
        return button
    }()
    let tableView = RestaurantsList()
    private var subscriber = Set<AnyCancellable>()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePanGesture()
        configureUI()
        configureButton()
        configureTableView()
    }
    //MARK: - Selectors
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        let newYPosition = y + translation.y
        switch recognizer.state {
        case .changed:
            if newYPosition == 100 { return }
            self.view.frame = CGRect(x: 0, y: newYPosition, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
//            delegate?.shouldHideResultView(shouldHide:newYPosition < UIScreen.main.bounds.height/1.5)
        case .ended:
            if newYPosition < UIScreen.main.bounds.height/1.5, newYPosition > UIScreen.main.bounds.height/3{
                animateOut()
//                delegate?.shouldHideResultView(shouldHide: true)
            }else if newYPosition > UIScreen.main.bounds.height/1.5{
                fold()
//                delegate?.shouldHideResultView(shouldHide: false)
            }else{
                animateIn()
            }
        default:
            break
        }
    }
    @objc func handleSaveButtonTapped(){
//        if self.list?.restaurantsID.isEmpty ?? true {
//            self.presentPopupViewWithoutButton(title: "Empty", subtitle: "Select at least one restaurant.")
//        }else{
//            let alertVC = UIAlertController(title: "Save list", message: nil, preferredStyle: .alert)
//            alertVC.addTextField { (tf) in
//                tf.placeholder = "Enter list name"
//                tf.keyboardType = .asciiCapable
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
//                let name = alertVC.textFields?[0].text
//                self.list?.name = name ?? ""
//                self.saveList()
//            }
//            alertVC.addAction(cancelAction)
//            alertVC.addAction(saveAction)
//            present(alertVC, animated: true, completion: nil)
//        }
    }
    @objc func handleUpdateButtonTapped(){
//        guard let list = self.list else { return }
//        let coreConnect = CoredataConnect(context: context)
//        if list.restaurantsID.isEmpty{
//            self.presentPopupViewWithButtonAndProvidePublisher(title: "Empty List", subtitle: "Empty List will be DELETED", buttonTitle: "Delete")
//                .sink {[weak self] _ in
//                    coreConnect.deleteList(list: list, success: {
//                        self?.state = .temp
//                    }, failure: { _ in
//                        
//                    })
//                }.store(in: &subscriber)
//        }else{
//            self.tableView.restaurants = self.tableView.restaurants.filter { $0.isSelected }
//            coreConnect.updateList(list: list)
//            self.state = .existed
//        }
    }
    //MARK: - Core Data API
    func saveList(){
//        guard let list = self.list else { return }
//        let coreConnect = CoredataConnect(context:  context)
//        coreConnect.saveList(list: list) { listID in
//            self.list?.id = listID
//            self.state = .existed
//        } failure: { error in
//
//        }
    }
}
//MARK: -  List's Restaurant update method
extension BottomSheetViewController {
//    func configureList(list: List?, restaurants: [Restaurant] = [], addRestaurant: Restaurant? = nil){
//        if list == nil{
//            let currentListState: ListState = (self.state == .temp) ? .temp : .edited
//            print(currentListState)
//            self.state = currentListState
//            if self.state == .temp{
//                self.configureTempList(restaurants: restaurants)
//            }else{
//                guard let restaurant = addRestaurant else { return }
//                self.configureEditedList(restaurant: restaurant)
//            }
//        }else if let list = list{
//            self.configureExistedList(list: list)
//        }
//    }
//    private func configureTempList(restaurants: [Restaurant]) {
//        let list = List(name: "My selected list", restaurants: restaurants, date: Date())
//        self.list = list
//        self.tableView.restaurants = restaurants
//        self.tableView.reloadData()
//    }
//    private func configureEditedList(restaurant:Restaurant) {
//        print("DEBUG: Restaurant is selected \(restaurant.isSelected)")
//        if let index = tableView.restaurants
//            .firstIndex(where: { $0.restaurantID == restaurant.restaurantID}){
//            tableView.restaurants[index].isSelected = restaurant.isSelected
//        }else{
//            if restaurant.isSelected{
//                list?.restaurants.append(restaurant)
//                self.tableView.restaurants.append(restaurant)
//            }else{
//                guard let newlistRestaurants =
//                        (list?.restaurants.filter({ $0.restaurantID != restaurant.restaurantID })) else { return }
//                list?.restaurants = newlistRestaurants
//                tableView.restaurants = tableView.restaurants.filter({ $0.restaurantID != restaurant.restaurantID })
//            }
//        }
//        self.tableView.reloadData()
//    }
//    private func configureExistedList(list: List){
//        self.list = list
//        self.state = .existed
//        tableView.restaurants = list.restaurants
//        print(list.restaurants)
//        self.tableView.reloadData()
//    }
}
//MARK: -  List State change animation
extension BottomSheetViewController{
    func didChangeState(){
        print("DEBUG: Current state is \(state) ")
        guard let list = self.list else { return }
        switch state {
        case .temp:
            self.titleLabel.text = "My selected list"
            self.saveButton.setTitle("Save list", for: .normal)
            self.saveButton.alpha = 1
            self.saveButton.isHidden = false
            self.updateButton.isHidden = true
        case .existed:
            UIView.animate(withDuration: 0.3, animations: {
                self.titleLabel.alpha = 0
                self.saveButton.isHidden = true
                self.updateButton.isHidden = true

            }) { _ in
                self.titleLabel.alpha = 1
//                self.titleLabel.text = list.name
                self.saveButton.alpha = 0
                self.updateButton.alpha = 0
            }
        case .edited:
//            let ns = NSMutableAttributedString(string: list.name,
//                                               attributes: [NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 16)!,
//                                                            NSAttributedString.Key.foregroundColor : UIColor.black])
//            ns.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor : UIColor.butterscotch]))
//            self.titleLabel.attributedText = ns
//            self.saveButton.setTitle("Save as new", for: .normal)
            self.saveButton.isHidden = false
            self.updateButton.isHidden = false
            self.saveButton.alpha = 1
            self.updateButton.alpha = 1
        }
        self.view.layoutIfNeeded()
    }
}
//MARK: - RestaurantsListDelegate
extension BottomSheetViewController: RestaurantsListDelegate{
//    func didSelectRestaurant(_ restaurant: Restaurant) {
//        self.state = self.state == .temp ? .temp : .edited
//
//        guard let index = self.tableView.restaurants
//            .firstIndex(where: {$0.restaurantID == restaurant.restaurantID}) else { return }
//        self.tableView.restaurants[index].isSelected.toggle()
//        self.tableView.reloadData()
//
//        if restaurant.isSelected{
//            self.list?.restaurants.append(restaurant)
//        }else{
//            guard let newListRestaurants = (self.list?.restaurants.filter{ $0.restaurantID != restaurant.restaurantID })
//                else { return }
//            self.list?.restaurants = newListRestaurants
//        }
//        delegate?.didSelectFromSheet(restaurant:restaurant)
//    }
}
//MARK: - UIGestureRecognizerDelegate
extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let y = view.frame.minY
        if y < 200{
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
        return false
    }
}

//MARK: - Auto layout and view set up method
extension BottomSheetViewController {
    func configurePanGesture(){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    func configureUI(){
        view.layer.cornerRadius = 24
        view.backgroundColor = .white
        view.addSubview(notchView)
        notchView.anchor(top: view.topAnchor, paddingTop: 8)
        notchView.centerX(inView: view)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: notchView.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)
    }
    func configureTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor, left:view.leftAnchor,
                         right: view.rightAnchor,bottom: view.bottomAnchor,
                         paddingTop: 16, paddingBottom: 200)
        tableView.listDelegate = self
        tableView.config = .sheet
    }
    func configureButton() {
        view.addSubview(saveButton)
        saveButton.anchor(top: titleLabel.topAnchor, right: view.rightAnchor, paddingRight: 16)
        view.addSubview(updateButton)
        updateButton.anchor(top: titleLabel.topAnchor, right: saveButton.leftAnchor, paddingRight: 16)
    }
    
    func animateIn(){
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(x: 0, y: 100,
                                     width: self.view.frame.width, height: self.view.frame.height)
            self.saveButton.alpha = 1
            self.updateButton.alpha = 1
        }
    }
    func animateOut(){
        let wheelHeight = 330 * view.widthMultiplier
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(x: 0, y: 100 + wheelHeight,
                                     width: self.view.frame.width, height: self.view.frame.height)
            
            self.saveButton.alpha = 1
            self.updateButton.alpha = 1
        }
    }
    func fold(){
        UIView.animate(withDuration: 0.3) {
            let wheelHeight = 330 * self.view.widthMultiplier
            let cardHeight = self.view.restaurantCardCGSize.height * 1.2
            let offset = 100 + wheelHeight + cardHeight
            self.view.frame = CGRect(x: 0, y: offset,
                                     width: self.view.frame.width, height: self.view.frame.height)
            self.saveButton.alpha = 0
            self.updateButton.alpha = 0
        }
    }
}
