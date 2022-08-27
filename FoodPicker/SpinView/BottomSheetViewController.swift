//
//  BottomSheetViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/8/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Combine
import CoreData

private let selectedIdentifier = "RestaurantListCell"

protocol BottomSheetViewControllerDelegate: AnyObject {
  //    func shouldHideResultView(shouldHide: Bool)
  //    func didSelectFromSheet(restaurant: Restaurant)
}
class BottomSheetViewController : UIViewController {
  //MARK: - Properties
  private let viewModel = BottomSheetViewModel()

  weak var delegate: BottomSheetViewControllerDelegate?

  private let notchView = NotchView()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Avenir-Heavy", size: 16)
    label.text = "My selected list"
    label.textColor = .black
    return label
  }()
  private let saveButton = ListSaveButton()
  private let updateButton = ListUpdateButton()
  private let tableView = RestaurantsList()
  private var set = Set<AnyCancellable>()
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configurePanGesture()
    configureUI()
    configureTableView()
    configureButton()

    bindRefresh()
    bindListState()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.refresh()
  }
  // MARK: - Binding
  private func bindRefresh() {
    viewModel.$isRefresh
      .sink { _ in
        self.tableView.restaurants = self.viewModel.restaurants
      }
      .store(in: &set)
  }
  //MARK: - Selectors
  @objc func panGesture(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self.view)
    let oldYPosition = self.view.frame.minY
    let newYPosition = oldYPosition + translation.y
    switch recognizer.state {
    case .changed:
      if newYPosition <= 0 { return }
      self.view.frame = CGRect(x: 0, y: newYPosition, width: view.frame.width, height: view.frame.height)
      recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    case .ended:
      if newYPosition < UIScreen.main.bounds.height / 1.5, newYPosition > UIScreen.main.bounds.height / 3 {
        self.animateIn(.middle)
      } else if newYPosition > UIScreen.main.bounds.height / 1.5 {
        self.animateIn(.bottom)
      } else {
        self.animateIn(.top)
      }
    default: break
    }
  }

  @objc func handleSaveButtonTapped(){
    let alertVC = UIAlertController(title: "Save list", message: nil, preferredStyle: .alert)
    alertVC.addTextField { (tf) in
      tf.placeholder = "Enter list name"
      tf.keyboardType = .asciiCapable
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
      let name = alertVC.textFields?[0].text
      self.viewModel.createList(name: name!)
    }
    alertVC.addAction(cancelAction)
    alertVC.addAction(saveAction)
    present(alertVC, animated: true, completion: nil)
    //    if self.list?.restaurantsID.isEmpty ?? true {
    //      self.presentPopupViewWithoutButton(title: "Empty", subtitle: "Select at least one restaurant.")
    //    }else{
    //
    //    }
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
}
//MARK: -  List's Restaurant update method
extension BottomSheetViewController {
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
  func bindListState() {
    viewModel.$listState
      .sink { state in
        switch state {
        case .temp:
          self.titleLabel.text = "My selected list"
          self.saveButton.setTitle("Save list", for: .normal)
          self.saveButton.alpha = 1
          self.saveButton.isHidden = false
          self.updateButton.isHidden = true
        case .existed:
          UIView.animate(withDuration: 0.2, animations: {
            self.titleLabel.alpha = 0
            self.saveButton.alpha = 0
            self.updateButton.alpha = 0
          }) { _ in
            self.titleLabel.alpha = 1
            self.titleLabel.text = self.viewModel.list?.name
            self.saveButton.isHidden = true
            self.updateButton.isHidden = true
          }
        case .edited:
          let ns = NSMutableAttributedString(string: self.viewModel.list?.name ?? "", attributes: .attributes([.arial16Bold, .black]))
          ns.append(NSAttributedString(string: "*", attributes: .butterScotch))
          self.titleLabel.attributedText = ns
          self.saveButton.setTitle("Save as new", for: .normal)
          self.saveButton.isHidden = false
          self.updateButton.isHidden = false
          self.saveButton.alpha = 1
          self.updateButton.alpha = 1
        }
        self.view.layoutIfNeeded()
      }
      .store(in: &set)
  }
}


//MARK: - RestaurantsListDelegate
extension BottomSheetViewController: RestaurantsListDelegate {
  func didTapActionButton(_ restaurant: Restaurant, indexPath: IndexPath) {
    OperationQueue.main.addOperation {
      self.viewModel.didTapActionButton(restaurant)
      self.tableView.reloadRows(at: [indexPath], with: .none)
    }
  }
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
    notchView.setDimension(width: 60, height: 4)
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
  }

  func configureButton() {
    view.addSubview(saveButton)
    saveButton.anchor(top: titleLabel.topAnchor, right: view.rightAnchor, paddingRight: 16)
    saveButton.setDimension(width: 104, height: 32)
    saveButton.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)

    view.addSubview(updateButton)
    updateButton.anchor(top: titleLabel.topAnchor, right: saveButton.leftAnchor, paddingRight: 16)
    updateButton.setDimension(width: 81, height: 32)
    updateButton.addTarget(self, action: #selector(handleUpdateButtonTapped), for: .touchUpInside)
  }
}

// MARK: - Position
extension BottomSheetViewController {
  enum Position {
    case top
    case middle
    case bottom

    var yPosition: CGFloat {
      switch self {
      case .top: return 100
      case .middle: return 72 + 330 + 24
      case .bottom: return 330 + 240 + 100
      }
    }
  }

  func animateIn(_ position: BottomSheetViewController.Position){
    UIView.animate(withDuration: 0.3) {
      self.view.frame = CGRect(x: 0, y: position.yPosition,
                               width: self.view.frame.width, height: self.view.frame.height)
      self.saveButton.alpha = position == .bottom ? 0 : 1
      self.updateButton.alpha = position == .bottom ? 0 : 1
    }
  }
}

