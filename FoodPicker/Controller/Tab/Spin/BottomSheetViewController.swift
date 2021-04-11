//
//  BottomSheetViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/8/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

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
    
    var gesture : UIPanGestureRecognizer?
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
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePanGesture()
        configureUI()
    }
    //MARK: - Selectors
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        if y + translation.y > 600 || y + translation.y <= 50 {
            return
        }
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    @objc func handleSaveButtonTapped(){
        if self.list?.restaurantsID.isEmpty ?? true {
            let alertVC = UIAlertController(title: "Empty List", message: "Select at least one restaurant.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertVC.addAction(action)
            present(alertVC, animated: true)
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
            let alertVC = UIAlertController(title: "Empty List", message: "Empty list will be removed.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "OK", style: .default){ _ in
                RestaurantService.shared.updateSavedList(list: list)
                self.state = .temp
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            present(alertVC, animated: true)
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
        gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture?.delegate = self
        view.addGestureRecognizer(gesture!)
    }
    func configureUI(){
        view.layer.cornerRadius = 24
        view.backgroundColor = .white
        view.addSubview(notchView)
        notchView.anchor(top: view.topAnchor, paddingTop: 8)
        notchView.centerX(inView: view)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: notchView.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)
        
        let buttonStack = UIStackView(arrangedSubviews: [updateButton, saveButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        buttonStack.distribution = .fillProportionally
        
        view.addSubview(buttonStack)
        buttonStack.anchor(right: view.rightAnchor, paddingRight: 16)
        buttonStack.centerY(inView: titleLabel)
        
        view.addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor, left:view.leftAnchor,
                         right: view.rightAnchor,bottom: view.bottomAnchor,
                         paddingTop: 16, paddingBottom: 200)
        tableView.listDelegate = self
        tableView.config = .sheet
        tableView.isLoading = nil
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
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
//        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if y == view.frame.height - 50 {
            gesture.isEnabled = false
        }else {
            gesture.isEnabled = true
        }
        if y <= 150{
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
        return false
    }
}
