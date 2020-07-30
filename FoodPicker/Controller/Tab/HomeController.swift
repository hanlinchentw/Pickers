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
    private var user : User?
    private var selectedRestaurants  = [Restaurant]() {
        didSet{
            guard let nav2 = viewControllers?[2] as? UINavigationController else { return }
            guard let action = nav2.viewControllers[0] as? ActionViewController else { return }
            let viewModel = LuckyWheelViewModel(restaurants: selectedRestaurants)
            action.selectedRestaurants = self.selectedRestaurants
            action.viewModel = viewModel
        }
    }
    private var likedrestaurants  = [Restaurant]() {
        didSet{
            guard let nav2 = viewControllers?[3] as? UINavigationController else { return }
            guard let favorite = nav2.viewControllers[0] as? FavoriteController else { return }
            favorite.likedRestaurants = likedrestaurants
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureUI()
        LocationHandler.shared.enableLocationServices()
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
            fetchUser()
            configureTabBar()
            configureTabBarController()
            confiugureObserver()
        }
    }
    func logUserOut(){
        do {
            try Auth.auth().signOut()
        }catch{
            print("DEBUG: Failed to sign out with error .. \(error.localizedDescription)")
        }
    }
    
    func fetchUser(){
        UserService.shared.fetchUser { (user) in
            self.user = user
        }
    }
    
    //MARK: - Helpers
    func configureTabBar(){
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 36
        tabBar.layer.masksToBounds = true
    }
    
    func configureTabBarController(){
        let main = MainPageController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = UINavigationController(rootViewController: main)
        
        let nav2 = UINavigationController(rootViewController: SearchController())
        let nav3 = UINavigationController(rootViewController: ActionViewController())
        let layout = UICollectionViewFlowLayout()
        
        let nav4 = UINavigationController(rootViewController: FavoriteController(collectionViewLayout: layout))
        let nav5 = UINavigationController(rootViewController: ProfileController())
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
        
    }
    
    func confiugureObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectRestaurant(noti:)),
                                               name: NSNotification.Name(rawValue: DID_SELECT_KEY),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didLikeRestaurant(noti:)),
                                               name: NSNotification.Name(rawValue: DID_LIKE_KEY),
                                               object: nil)
    }
    
    //MARK: - API
    func updateLikeRestaurant(restaurant: Restaurant){
        
    }
    //MARK: - Selectors
    
    @objc func didSelectRestaurant(noti : NSNotification){
        if let info = noti.userInfo {
            guard var restaurant = info["Restaurant"] as? Restaurant else { return}
          
            if restaurant.isSelected {
                restaurant.isSelected = false
                selectedRestaurants = selectedRestaurants.filter{($0.restaurantID != restaurant.restaurantID)}
            }else {
                restaurant.isSelected = true
                selectedRestaurants.append(restaurant)
            }
        }
    }
    
    @objc func didLikeRestaurant(noti : NSNotification){
        if let info = noti.userInfo {
            guard var restaurant = info["Restaurant"] as? Restaurant else { return}
          
            if restaurant.isLiked {
                restaurant.isLiked = false
                likedrestaurants = likedrestaurants.filter{($0.restaurantID != restaurant.restaurantID)}
            }else {
                restaurant.isLiked = true
                likedrestaurants.append(restaurant)
            }
        }
    }
}


