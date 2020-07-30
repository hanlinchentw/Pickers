//
//  DetailController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/19.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class DetailController : UIViewController {
    //MARK: - Prorperties
    private var restaurant : Restaurant
    private let scrollView = DetailScrollView()
    //MARK: - Lifecycle
    init(restaurant:Restaurant) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetail()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        configureScrollView()
    }
    //MARK: - API
    func fetchDetail(){
        NetworkService.shared.fetchDetail(id: restaurant.restaurantID) { (detail) in
            guard let detail = detail else { return }
            print(detail)
        }
    }
    //MARK: - Helpers
    func configureScrollView(){
        scrollView.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height-300)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
    }
    //MARK: - Selectors
    
}
