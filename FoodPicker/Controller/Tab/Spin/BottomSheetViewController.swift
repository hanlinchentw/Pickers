//
//  BottomSheetViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/8/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let selectedIdentifier = "RestaurantListCell"

class BottomSheetViewController : UIViewController {
    //MARK: - Properties
    var selectedRestaurants = [Restaurant]()  {  didSet { self.tableView.restaurants = self.selectedRestaurants }}
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
    private let tableView = RestaurantsList()
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
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        view.addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor, left:view.leftAnchor,
                              right: view.rightAnchor,bottom: view.bottomAnchor,
                              paddingTop: 16, paddingBottom: 200)
    }
}
//MARK: - UIGestureRecognizerDelegate
extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if y == view.frame.height - 100 {
            gesture.isEnabled = false
        }else {
            gesture.isEnabled = true
        }
        if y <= 100{
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
        return false
    }
}
