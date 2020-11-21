//
//  MainPageController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import Firebase

private let foodCardSection = "FoodCardCell"
private let headerCell = "SortHeader"
private let footerCell = "AllRestaurantsSection"

class MainPageController: UIViewController {
    //MARK: - Properties
    private let navBarView = MainPageNavigationBar()
    private let locationManager = LocationHandler.shared.locationManager
    private let mapVC = MapViewController()
    private let categoryVC : CategoriesViewController = {
        let cv = CategoriesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        return cv
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationHandler.shared.enableLocationServices()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = true
    }
    //MARK: - Helpers
    func configureUI(){
        guard let map = mapVC.view else { return }
        self.addChild(mapVC)
        view.insertSubview(map, at: 1)
        map.isHidden = true
        guard let categoryView = categoryVC.view else { return }
        self.addChild(categoryVC)
        view.insertSubview(categoryView, at: 1)
        categoryView.isHidden = false
        navBarView.delegate = self
        view.addSubview(navBarView)
        navBarView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 104)
        categoryView.anchor(top: navBarView.bottomAnchor,left: view.leftAnchor,
                            right: view.rightAnchor, bottom: view.bottomAnchor,
                            paddingTop: 16, paddingBottom: 80)
    }
}
//MARK: - MainPageHeaderDelegate
extension MainPageController : MainPageHeaderDelegate {
    func handleHeaderGotTapped() {
        mapVC.view.isHidden.toggle()
        categoryVC.view.isHidden.toggle()
    }
}
