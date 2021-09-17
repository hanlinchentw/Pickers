//
//  HomeController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Firebase
import CoreData

enum SelectRestaurantResult: Error {
    case success
    case upToLimit
    case error
}
class HomeController : UITabBarController, MBProgressHUDProtocol {
    
    //MARK: - Properties
    var selectedRestaurants  = [Restaurant]()
    private let numOfSelectedLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.arialBoldMT
        label.textColor = .white
        return label
    }()
    private lazy var actionIconView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .butterscotch
        iv.image = UIImage(named: "spinActive")
        iv.contentMode = .scaleAspectFit
        iv.setDimension(width: 54, height: 54)
        iv.layer.cornerRadius = 54 / 2
        
        iv.addSubview(numOfSelectedLabel)
        numOfSelectedLabel.center(inView: iv)
        return iv
    }()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG:App folder: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        authenticateUserAndConfigureUI()
        overrideUserInterfaceStyle = .light
//        try? Auth.auth().signOut()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = 100 * view.heightMultiplier
        var frame = tabBar.frame
        frame.size.height = height
        frame.origin.y = self.view.frame.size.height - height
        tabBar.frame = frame
    }
    //MARK: - API
    func authenticateUserAndConfigureUI(){
        print("DEBUG: Authenticate ...  ")
        if Auth.auth().currentUser == nil {
            print("DEBUG: User has not logged in yet.")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: IntroController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }else{
            configureTabBar()
            configureTabBarController()
        }
    }
    func cleanUpLocalDatabase(){
        let connect = CoredataConnect(context: context)
        connect.deleteAllRestaurant(in: likedEntityName)
        connect.deleteAllRestaurant(in: selectedEntityName)
    }
    
    //MARK: - Helpers
    func configureActionIcon(){
        if selectedRestaurants.count == 0 {
            numOfSelectedLabel.text = nil
            actionIconView.image = UIImage(named: "spinActive")
        }else {
            actionIconView.image = nil
            numOfSelectedLabel.changeLabelWithBounceAnimation(changeTo: "\(selectedRestaurants.count)")
        }
    }
    func configureTabBar(){
        view.backgroundColor = .backgroundColor
        tabBar.addSubview(actionIconView)
        print(UIScreen.main.bounds.height)
        let offset = UIScreen.main.bounds.height < 700 ? 0 : -10 * view.heightMultiplier
        actionIconView.center(inView: tabBar, yConstant: offset)
        
        tabBar.backgroundColor = .white
        tabBar.backgroundImage = UIImage(named: "bar")?.withRenderingMode(.alwaysOriginal)
        tabBar.layer.cornerRadius = 36
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        self.selectedIndex = 0
    }
    
    func configureTabBarController(){
        // Create main page view controller
        let main = MainPageController()
        let nav1 = templateNavigationController(image: UIImage(named: "homeUnselectedS"),
                                                rootViewController: main)
        nav1.tabBarItem.selectedImage = UIImage(named: "homeSelectedS")?.withRenderingMode(.alwaysOriginal)
        // Create searcg page view controller
        let search = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav2 = templateNavigationController(image: UIImage(named: "searchUnselectedS"),
                                                rootViewController: search)
        nav2.tabBarItem.selectedImage = UIImage(named: "searchSelectedS")?.withRenderingMode(.alwaysOriginal)
        // Create Spin page view controller
        let action = ActionViewController()
        let nav3 = templateNavigationController(image: UIImage(named: ""),
                                                rootViewController: action)
        // Create favorite View controller
        let favorite = FavoriteController()
        let nav4 = templateNavigationController(image: UIImage(named: "favoriteUnselectedS"),
                                                rootViewController: favorite)
        favorite.fetchLikedRestauants()
        nav4.tabBarItem.selectedImage = UIImage(named: "icnTabHeartSelected")?.withRenderingMode(.alwaysOriginal)
        
        // Create profile view controller
        let email = Auth.auth().currentUser?.email ?? " User email can't find"
        let profile = ProfileController(email: email)
        profile.delegate = self
        let nav5 = templateNavigationController(image: UIImage(named: "profileUnselectedS"),
                                                rootViewController: profile)
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
    }
    func templateNavigationController(image: UIImage?, rootViewController:UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        let offset = view.heightMultiplier * 12
        nav.tabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0)
        return nav
    }
}

//MARK: -SelectRestaurant Data flow
extension HomeController {
    func updateSelectedRestaurants(from controller: UIViewController, restaurant: Restaurant) throws {
        if selectedRestaurants.count == 8, restaurant.isSelected { throw SelectRestaurantResult.upToLimit }
        self.didSelect(restaurant: restaurant)
        self.configureActionIcon()
        if controller.isKind(of: MainPageController.self)
            || controller.isKind(of: FavoriteController.self)
            || controller.isKind(of: SearchController.self) {
            updateSelectedRestaurantsForSpinPage(restaurant: restaurant)
        }
        if controller.isKind(of: ActionViewController.self)
            || controller.isKind(of: FavoriteController.self)
            || controller.isKind(of: SearchController.self){
            updateSelectedRestaurantsForMainPage(restaurant: restaurant)
        }
    }
    
    private func updateSelectedRestaurantsForSpinPage(restaurant: Restaurant){
        guard let nav = viewControllers?[2] as? UINavigationController else { return }
        guard let action = nav.viewControllers[0] as? ActionViewController else { return }
        let vm = LuckyWheelViewModel(restaurants: self.selectedRestaurants)
        action.selectedRestaurants = self.selectedRestaurants
        action.viewModel = vm
        if action.state == .temp || action.state == nil{
            action.configureList(list: nil)
        }else if action.state == .existed || action.state == .edited{
            action.configureList(list: nil, addRestaurant: restaurant)
        }
    }
    private func updateSelectedRestaurantsForMainPage(restaurant: Restaurant) {
        guard let nav = viewControllers?[0] as? UINavigationController else { return }
        guard let main = nav.viewControllers[0] as? MainPageController else { return }
        guard let cate = main.children[1] as? CategoriesViewController else { return }
        cate.updateSelectStatus(restaurantID: restaurant.restaurantID)
    }
    
    func didSelect(restaurant : Restaurant){
        if restaurant.isSelected, selectedRestaurants.count < 8 {
            selectedRestaurants.append(restaurant)
        }else {
            selectedRestaurants = selectedRestaurants.filter{($0.restaurantID != restaurant.restaurantID)}
        }
    }
    func deselectAllFromActionViewController(actionVC: ActionViewController){
        self.selectedRestaurants.forEach { try! updateSelectedRestaurants(from: actionVC, restaurant: $0)}
        selectedRestaurants.removeAll()
        let connect = CoredataConnect(context: context)
        connect.deleteAllRestaurant(in: selectedEntityName)
    }
}
//MARK: -  Search Restaurants from category cards
extension HomeController {
    func searchRestaurantsFromCategoryCard(textOnCard text: String) {
        self.showLoadingAnimation()
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
            self.selectedIndex = 1
        } completion: { _ in
            guard let nav = self.viewControllers?[1] as? UINavigationController else { return }
            guard let searchVC = nav.viewControllers[0] as? SearchController else { return }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if searchVC.isViewLoaded {
                    searchVC.searchRestaurants(withKeyword: text)
                    timer.invalidate()
                }
            }
        }
    }
}
//MARK: - ProfileControllerDelegate
extension HomeController : ProfileControllerDelegate {
    func logOutButtonTapped() {
        authenticateUserAndConfigureUI()
    }
}
