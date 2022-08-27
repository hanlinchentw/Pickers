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

}
class BottomSheetViewController : UIViewController {
  //MARK: - Properties
  private let viewModel = BottomSheetViewModel()
  weak var delegate: BottomSheetViewControllerDelegate?

  private let notchView = NotchView()
  private let titleLabel = UILabel("My selected list", font: .arialBoldMT, color: .black)
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
    #warning("TODO: 至少要有一間餐廳被選擇")
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
  }

  @objc func handleUpdateButtonTapped() {
  #warning("TODO: 全部都取消的話，跳刪除列表提示")
    viewModel.updateList()
    tableView.reloadData()
  }
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

