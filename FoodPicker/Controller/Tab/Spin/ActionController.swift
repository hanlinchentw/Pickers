//
//  ActionController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import iOSLuckyWheel

class ActionViewController: UIViewController {
    //MARK: - Properties
    var viewModel: LuckyWheelViewModel? { didSet{ configureWheel() } }
    
    private let resultView : ResultView = {
        let result = ResultView()
        result.alpha = 0
        return result
    }()
    private var startButton  : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: .normal)
        button.tintColor = .black
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
    private var wheel : LuckyWheel?
    private let bottomSheetVC = BottomSheetViewController()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWheel()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBottomSheetView()
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
    }
    //MARK: - Helpers
    func configureUI(){
        view.addSubview(listButton)
        listButton.anchor(top: view.topAnchor, right: view.rightAnchor,
                          paddingTop: 52, paddingRight: 20,
                          width: 40, height: 40)
        
    }
    func configureBottomSheetView(){
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0,y: self.wheel!.frame.maxY + 24,width: width, height: height)
    }
    func configureWheel(){
        wheel = LuckyWheel(frame: CGRect(x: 0, y: 0, width: 330 , height: 330))
        wheel?.delegate = self
        wheel?.dataSource = self
        wheel?.isUserInteractionEnabled = false
        
        self.view.insertSubview(wheel!, at: 1)
        wheel?.center = view.center
        wheel?.frame.origin.y = view.frame.origin.y + 48 + 24
        wheel?.animateLanding = false
        
        view.addSubview(startButton)
        startButton.center(inView: wheel!)
        startButton.setDimension(width: 40, height: 40)
        startButton.layer.cornerRadius = 40 / 2
        startButton.isUserInteractionEnabled = !(viewModel == nil)
    }
    func configureResultView(valueRelateToResult value: Int){
        guard let viewModel = viewModel else { return }
        view.addSubview(resultView)
        resultView.setDimension(width: 280, height: 240)
        resultView.center(inView: view, yConstant: -100)
        
        resultView.restaurant = viewModel.restaurants[value - 1]
        let blureffect = UIBlurEffect(style: .regular)
        let visualeffect = UIVisualEffectView(effect: blureffect)
        self.view.insertSubview(visualeffect, belowSubview: resultView)
        UIView.animate(withDuration: 2) {
            self.resultView.alpha = 1
            visualeffect.fit(inView: self.view)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    func configureList(list: List?){
        if list == nil{
            guard let viewModel = viewModel else { return }
            let resID = viewModel.restaurants.map{$0.restaurantID}
            let timestamp = NSDate().timeIntervalSince1970
            var list = List(name: "My selected list", restaurantsID: resID, timestamp: timestamp)
            list.restaurants = viewModel.restaurants
            bottomSheetVC.list = list
            bottomSheetVC.tableView.restaurants = viewModel.restaurants
            bottomSheetVC.state = (bottomSheetVC.state == .temp) ? .temp : .edited
        }else if let list = list{
            bottomSheetVC.list = list
            bottomSheetVC.tableView.restaurants = list.restaurants
            bottomSheetVC.state = .existed
            let viewModel = LuckyWheelViewModel(restaurants: list.restaurants)
            self.viewModel = viewModel
        }
    }
    //MARK: - Selectors
    @objc func handleStartButtonTapped(){
        guard let viewModel = self.viewModel else { return }
        wheel?.manualRotation(aCircleTime: 1)
        let resultNumber = Int.random(in: 1...viewModel.restaurants.count)
        self.wheel?.setTarget(section: resultNumber)
        startButton.isHidden = true
        bottomSheetVC.view.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.wheel?.manualRotation(aCircleTime: 5)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.wheel?.stop()
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
extension ActionViewController : LuckyWheelDelegate, LuckyWheelDataSource {
    func wheelDidChangeValue(_ newValue: Int) {
        configureResultView(valueRelateToResult: newValue)
    }
    func numberOfSections() -> Int {
        guard let viewModel = self.viewModel else { return 1 }
        return viewModel.numOfSection
    }
    
    func itemsForSections() -> [WheelItem] {
        let item = WheelItem(title: "", titleColor: .customblack, itemColor: .pale)
        guard let viewModel = viewModel else { return [item]}
        return viewModel.itemForSection
    }
}
//MARK: - ListTableViewControllerDelegate
extension ActionViewController: ListTableViewControllerDelegate{
    func didSelectList(_ controller: ListTableViewController, list: List) {
        configureList(list: list)
        controller.navigationController?.popViewController(animated: true)
    }
    func willPopViewController(_ controller: ListTableViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
}

//MARK: - ResultView
class ResultView : RestaurantCardCell {
    //MARK: - Properties
    override var restaurant : Restaurant! { didSet{ configure() }}
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func configure() {
        let viewModel = CardCellViewModel(restaurant: restaurant)
        restaurantName.text = restaurant.name
        priceLabel.attributedText = viewModel.priceString
        ratedLabel.attributedText = viewModel.ratedString
        businessLabel.attributedText = viewModel.businessString
    
        
    }
}
