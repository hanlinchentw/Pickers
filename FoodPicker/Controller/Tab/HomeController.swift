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

class HomeController : UITabBarController {

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
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        authenticateUserAndConfigureUI()
//        logUserOut()
    }
    //MARK: - API
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
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
    func logUserOut(){
        do { try Auth.auth().signOut() }catch{ print("DEBUG: Failed to sign out with error ...\(error.localizedDescription)") } }
    //MARK: - Helpers
    func configureActionIcon(){
        if selectedRestaurants.count == 0 {
            numOfSelectedLabel.text = nil
            actionIconView.image = UIImage(named: "spinActive")
        }else {
            actionIconView.image = nil
            numOfSelectedLabel.text = "\(selectedRestaurants.count)"
        }
    }
    func configureTabBar(){
        view.backgroundColor = .backgroundColor
        view.isOpaque = true
        tabBar.addSubview(actionIconView)
        actionIconView.center(inView: tabBar, yConstant: -8)
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 36
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
    }
    
    func configureTabBarController(){
        // Create main page view controller
        let main = MainPageController()
        let nav1 = templateNavigationController(image: UIImage(named: "homeUnselectedS"),
                                                rootViewController: main)
        nav1.tabBarItem.selectedImage = UIImage(named: "homeSelectedS")?.withRenderingMode(.alwaysOriginal)
        main.preloadData()
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
        nav4.tabBarItem.selectedImage = UIImage(named: "icnTabHeartSelected")?.withRenderingMode(.alwaysOriginal)

        // Create profile view controller
        let profile = ProfileController()
        let nav5 = templateNavigationController(image: UIImage(named: "profileUnselectedS"),
                                                rootViewController: profile)
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
    }
    func templateNavigationController(image: UIImage?, rootViewController:UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
        return nav
    }
    
    //MARK: - SelectRestaurant Data flow
    func updateSelectedRestaurants(from controller: UIViewController, restaurant: Restaurant) throws {
        self.didSelect(restaurant: restaurant)
        guard self.selectedRestaurants.count <= 8  else { throw SelectRestaurantResult.upToLimit }
            self.configureActionIcon()
            if controller.isKind(of: MainPageController.self) || controller.isKind(of: FavoriteController.self){
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
            if controller.isKind(of: ActionViewController.self) || controller.isKind(of: FavoriteController.self){
                guard let nav = viewControllers?[0] as? UINavigationController else { return }
                guard let main = nav.viewControllers[0] as? MainPageController else { return }
                guard let cate = main.children[1] as? CategoriesViewController else { return }
                cate.updateSelectStatus(restaurantID: restaurant.restaurantID)
            }
    }
    func didSelect(restaurant : Restaurant){
        if restaurant.isSelected {
            selectedRestaurants.append(restaurant)
        }else {
            selectedRestaurants = selectedRestaurants.filter{($0.restaurantID != restaurant.restaurantID)}
        }
    }
    func deselectAllFromActionViewController(actionVC: ActionViewController){
        self.selectedRestaurants.forEach { try! updateSelectedRestaurants(from: actionVC, restaurant: $0)}
        selectedRestaurants.removeAll()
        let connect = CoredataConnect(context: context)
        connect.deselectAllRestaurants()
    }
}
