//
//  MainViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/5.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class MainViewController: UIViewController {
  // MARK: - Store
  private var listVC: UIViewController!
  private let mapVC: MapViewController = .init()
  weak var coordinator: MainCoordinator? {
    didSet {
      setupMapView()
      setupListView(coordinator: coordinator!)
    }
  }
  // MARK: - State
  @Published var mainPageMode: MainPageMode = .map
  private var set = Set<AnyCancellable>()
  // MARK: - Lifecycle
  override func viewDidLoad() {
    bindMainPageMode()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    self.tabBarController?.tabBar.isHidden = false
  }
}
// MARK: - Binding
extension MainViewController {
  func bindMainPageMode() {
    self.$mainPageMode
      .receive(on: DispatchQueue.main)
      .dropFirst()
      .sink { mode in
        switch mode {
        case .list:
          UIView.animate(withDuration: 0.3) {
            self.mapVC.view.alpha = 0
            self.listVC.view.alpha = 1
            self.tabBarController?.tabBar.alpha = 1
          }
        case .map:
          UIView.animate(withDuration: 0.3) {
            self.mapVC.view.alpha = 1
            self.listVC.view.alpha = 0
            self.tabBarController?.tabBar.alpha = 0
          }
        }
      }
      .store(in: &set)
  }
}
// MARK: - Set up UI
extension MainViewController {
  func setupListView(coordinator: MainCoordinator) {
    listVC = UIHostingController(
			rootView: MainListView(locationService: LocationService.shared)
        .environmentObject(coordinator)
        .environment(\.managedObjectContext, CoreDataManager.sharedInstance.managedObjectContext)
    )
    self.addChild(listVC)
    guard let listView = listVC.view else {
      return
    }
    self.view.addSubview(listView)
    listView.fit(inView: self.view)
  }

  func setupMapView() {
    mapVC.coordinator = coordinator
    self.addChild(mapVC)
    guard let mapView = mapVC.view else {
      return
    }
    mapView.alpha = 0
    self.view.addSubview(mapView)
    mapView.fit(inView: self.view)
  }
}

extension MainViewController {
  enum MainPageMode {
    case list
    case map
  }
}
