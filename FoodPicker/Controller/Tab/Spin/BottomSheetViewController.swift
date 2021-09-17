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

class BottomSheetViewController : UIViewController {
    //MARK: - Properties
    var list: List?
    var state: ListState = .temp { didSet{ didChangeState() }}
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
        button.setDimension(width: 81 , height: 32)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleUpdateButtonTapped), for: .touchUpInside)
        button.alpha = 0
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
        let newHeight = y + translation.y
        switch recognizer.state {
        case .changed:
            self.view.frame = CGRect(x: 0, y: newHeight, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        case .ended:
            if newHeight > UIScreen.main.bounds.height/3 {
                animateOut()
            }else{
                animateIn()
            }
        default:
            break
        }
    }
    func animateIn(){
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    func animateOut(){
        let wheelHeight = 330 * view.widthMultiplier
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(x: 0, y: 100+wheelHeight, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    @objc func handleSaveButtonTapped(){
        if self.list?.restaurantsID.isEmpty ?? true {
            self.presentPopupViewWithoutButton(title: "Empty", subtitle: "Select at least one restaurant.")
        }else{
            let alertVC = UIAlertController(title: "Save list", message: nil, preferredStyle: .alert)
            alertVC.addTextField { (tf) in
                tf.placeholder = "Enter list name"
                tf.keyboardType = .asciiCapable
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
                let name = alertVC.textFields?[0].text
                self.list?.name = name ?? ""
                self.saveList()
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(saveAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
    @objc func handleUpdateButtonTapped(){
        guard let list = self.list else { return }
        if list.restaurantsID.isEmpty{
            self.presentPopupViewWithButtonAndProvidePublisher(title: "Empty List", subtitle: "Empty List will be DELETED", buttonTitle: "Delete")
                .sink {[weak self] _ in
                    RestaurantService.shared.updateSavedList(list: list)
                    self?.state = .temp
                }.store(in: &subscriber)
        }else{
            self.cleanUnselectRestaurants {
                guard self.tableView.restaurants.count == self.list?.restaurantsID.count else { return }
                RestaurantService.shared.updateSavedList(list: list)
                self.state = .existed
            }
        }
    }
    //MARK: - Helpers
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
        tableView.isLoading = nil
    }
    func configureButton() {
        let buttonStack = UIStackView(arrangedSubviews: [updateButton, saveButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        buttonStack.distribution = .fillProportionally
        
        view.addSubview(buttonStack)
        buttonStack.anchor(right: view.rightAnchor, paddingRight: 16)
        buttonStack.centerY(inView: titleLabel)
    }
    
    func didChangeState(){
        print("DEBUG: Current state is \(state) ")
        guard let list = self.list else { return }
        switch state {
        case .temp:
            self.titleLabel.text = "My selected list"
            self.saveButton.setTitle("Save list", for: .normal)
            self.updateButton.alpha = 0
        case .existed:
            UIView.animate(withDuration: 0.3, animations: {
                self.titleLabel.alpha = 0
                self.saveButton.alpha = 0
                self.updateButton.alpha = 0
            }) { _ in
                self.titleLabel.alpha = 1
                self.titleLabel.text = list.name
            }
        case .edited:
            let ns = NSMutableAttributedString(string: list.name, attributes: [NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.black])
            ns.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor : UIColor.butterscotch]))
            
            self.titleLabel.attributedText = ns
            self.updateButton.alpha = 1
            self.saveButton.setTitle("Save as new", for: .normal)
            self.saveButton.alpha = 1
        }
        self.view.layoutIfNeeded()
    }
    func cleanUnselectRestaurants(completion: ()-> Void){
        self.tableView.restaurants = self.tableView.restaurants.filter { $0.isSelected }
        completion()
    }
    //MARK: - API
    func saveList(){
        guard let list = self.list else { return }
        self.list?.id = RestaurantService.shared.saveList(list: list)
        self.state = .existed
    }
}
extension BottomSheetViewController: RestaurantsListDelegate{
    func didSelectRestaurant(_ restaurant: Restaurant) {
        self.state = self.state == .temp ? .temp : .edited
        
        guard let index = self.tableView.restaurants
            .firstIndex(where: {$0.restaurantID == restaurant.restaurantID}) else { return }
        self.tableView.restaurants[index].isSelected.toggle()
        self.tableView.reloadData()
        
        if restaurant.isSelected{
            self.list?.restaurantsID.append(restaurant.restaurantID)
        }else{
            guard let newListID = (self.list?.restaurantsID.filter{ $0 != restaurant.restaurantID })
                else { return }
            self.list?.restaurantsID = newListID
        }
        guard let parent = self.parent as? ActionViewController else { return }
        parent.didSelectFromSheet(restaurant:restaurant)
    }
}
//MARK: - UIGestureRecognizerDelegate
extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let y = view.frame.minY
        if y <= 100{
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
        return false
    }
}
