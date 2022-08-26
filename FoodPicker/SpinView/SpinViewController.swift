//
//  ActionController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData
import Combine

class SpinViewController: UIViewController {
  static let wheelWidth: CGFloat = 330
  static let wheelHeight: CGFloat = 330
  //MARK: - Properties
  let presenter = SpinWheelPresenter()

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

  private var spinWheel = SpinWheel(frame: CGRect(x: 0, y: 0, width: wheelWidth, height: wheelHeight))

  private let bottomSheetVC = BottomSheetViewController()
  private var set = Set<AnyCancellable>()
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureWheel()
    configureListButton()
    configureResultView()
    presenter.refresh()

    presenter.$isRefresh
      .sink { _ in
        self.spinWheel.reloadData()
        self.startButton.isUserInteractionEnabled = self.presenter.isSpinButtonEnabled
      }
      .store(in: &set)
    //    observeSelectedRestaurantChange()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureBottomSheetView()
    presenter.refresh()

    view.backgroundColor = .backgroundColor
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.isTranslucent = true
    tabBarController?.tabBar.isHidden = false
    tabBarController?.tabBar.isTranslucent = true
  }
  //MARK: - Selectors
  @objc func handleStartButtonTapped() {
    self.startButton.changeImageButtonWithBounceAnimation(changeTo: "btnSpin")
    let resultNumber = Int.random(in: 1...presenter.restaurants.count)
    wheelSpin(targetIndex: resultNumber)

    bottomSheetVC.fold()
    self.resultView.alpha = 1
  }

  func wheelSpin(targetIndex: Int){
    self.spinWheel.setTarget(section: targetIndex)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
      self.spinWheel.manualRotation(aCircleTime: 0.15)
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        self.spinWheel.stop()
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
extension SpinViewController : SpinWheelDelegate, SpinWheelDataSource {
  func wheelDidChangeValue(_ newValue: Int) {
    self.configureResult(valueRelateToResult: newValue)
  }
  func numberOfSections() -> Int {
    return presenter.numOfSection
  }
  func itemsForSections() -> [WheelItem] {
    return presenter.itemForSection
  }
}
//MARK: - Observe entityChange
extension SpinViewController {
  //  func observeSelectedRestaurantChange() {
  //    NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
  //      .sink { notification in
  //        print("SpinViewController.0")
  //        guard let userInfo = notification.userInfo else { return }
  //        let insert = userInfo[NSInsertedObjectsKey] as? Set<SelectedRestaurant>
  //        let delete = userInfo[NSDeletedObjectsKey] as? Set<SelectedRestaurant>
  //        if insert == nil || delete == nil { return }
  //
  //        print("SpinViewController.1")
  //        let newSource: Array<SelectedRestaurant>? = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext)
  //        print("SpinViewController.2")
  //        if let selectedRestaurants = newSource {
  //          print("SpinViewController.observeSelectedRestaurantChange \(selectedRestaurants)")
  //          self.selectedRestaurants = selectedRestaurants.map { $0.restaurant }
  //          self.presenter = SpinWheelPresenter(restaurants: self.selectedRestaurants)
  //        }
  //      }
  //      .store(in: &set)
  //  }
}
//MARK: - list method
extension SpinViewController {
  private func ReplaceAllSelectedRestaurantsWithExistedList(list: _List){
    //        self.deselectAll()
    //        list.restaurants.forEach{
    //            self.updateSelectedRestaurantsInCoredata(context: self.context, restaurant: $0)
    //        }
    //        self.configureList(list: list)
  }
}
//MARK: -  BottomSheetDelegate
extension SpinViewController: BottomSheetViewControllerDelegate{
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
}
//MARK: - ListTableViewControllerDelegate
extension SpinViewController: ListTableViewControllerDelegate{
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
extension SpinViewController: SpinResultViewDelegate {
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
extension SpinViewController {
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
extension SpinViewController {
  func configureWheel(){
    spinWheel.delegate = self
    spinWheel.dataSource = self
    spinWheel.isUserInteractionEnabled = false
    spinWheel.animateLanding = true

    let wheelContainerView = UIView()
    view.addSubview(wheelContainerView)
    wheelContainerView.centerX(inView: self.view)
    wheelContainerView.anchor(top: self.view.topAnchor, paddingTop: 60)
    wheelContainerView.setDimension(width: Self.wheelWidth, height: Self.wheelHeight)

    wheelContainerView.addSubview(spinWheel)
    spinWheel.fit(inView: wheelContainerView)

    wheelContainerView.addSubview(startButton)
    startButton.center(inView: wheelContainerView)
    startButton.setDimension(width: 85, height: 85)
    startButton.layer.cornerRadius = 40 / 2
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
    let offset = 72 * view.widthMultiplier + Self.wheelHeight + 24

    bottomSheetVC.view.frame = CGRect(x: 0, y: offset, width: width, height: height)
  }

  func configureResultView(){
    resultView.alpha = 0
    let resultViewWidth = self.view.restaurantCardCGSize.width * 1.3
    let resultViewHeight = self.view.restaurantCardCGSize.height * 1.2

    view.addSubview(resultView)
    resultView.centerX(inView: self.view)
    let offset = 72 * view.widthMultiplier + Self.wheelHeight + 24
    resultView.anchor(top: self.view.topAnchor, paddingTop: offset)
    resultView.setDimension(width: resultViewWidth, height: resultViewHeight)
  }
  func configureResult(valueRelateToResult value: Int){
    //        guard let restaurant = self.presenter?.restaurants[value-1] else { return }
    //        self.resultView.restaurant = restaurant
    //        self.resultView.delegate =  self
  }
}
