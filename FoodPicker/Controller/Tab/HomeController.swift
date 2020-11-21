//
//  HomeController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Firebase

class HomeController : UITabBarController {
    //MARK: - Properties
    private var selectedRestaurants  = [Restaurant]() {
        didSet{
            configureActionIcon()
            guard let nav2 = viewControllers?[2] as? UINavigationController else { return }
            guard let action = nav2.viewControllers[0] as? ActionViewController else { return }
            let viewModel = LuckyWheelViewModel(restaurants: selectedRestaurants)
            action.viewModel = viewModel
            action.configureList(list:nil)
        }
    }
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
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        print("DEBUG: Picker path is at ... \(paths[0])")
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
        let main = MainPageController()
        let nav1 = templateNavigationController(image: UIImage(named: "homeUnselectedS"),
                                                rootViewController: main)
        nav1.tabBarItem.selectedImage = UIImage(named: "homeSelectedS")?.withRenderingMode(.alwaysOriginal)
        
        let search = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav2 = templateNavigationController(image: UIImage(named: "searchUnselectedS"),
                                                rootViewController: search)
        nav2.tabBarItem.selectedImage = UIImage(named: "searchSelectedS")?.withRenderingMode(.alwaysOriginal)
        
        let action = ActionViewController()
        let nav3 = templateNavigationController(image: UIImage(named: ""),
                                                rootViewController: action)
 
        
        
        let favorite = FavoriteController()
        let nav4 = templateNavigationController(image: UIImage(named: "favoriteUnselectedS"),
                                                rootViewController: favorite)
        nav4.tabBarItem.selectedImage = UIImage(named: "icnTabHeartSelected")?.withRenderingMode(.alwaysOriginal)

        
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
    //MARK: - Selectors
    func didSelect(restaurant : Restaurant){
        print("DEBUG: Did select")
        if restaurant.isSelected {
            selectedRestaurants.append(restaurant)
        }else {
            selectedRestaurants = selectedRestaurants.filter{($0.restaurantID != restaurant.restaurantID)}
        }
    }
}

