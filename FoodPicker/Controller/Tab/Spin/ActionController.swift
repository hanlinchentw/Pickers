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
    var selectedRestaurants = [Restaurant]() { didSet { bottomSheetVC.selectedRestaurants = selectedRestaurants }}
    var viewModel: LuckyWheelViewModel? { didSet{ configureWheel() } }
    private var wheel : LuckyWheel?
    private let bottomSheetVC = BottomSheetViewController()
    
    private let resultView : ResultView = {
        let result = ResultView()
        result.alpha = 0
        return result
    }()
    private var startButton  : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: .normal)
        button.backgroundColor = .customblack
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleStartButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWheel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBottomSheetView()
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
    }
    //MARK: - Helpers
    func configureBottomSheetView(){
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)

        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0,y: self.wheel!.frame.maxY + 16,width: width, height: height)
    }
    func configureWheel(){
        wheel = LuckyWheel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 40 , height: 365.6))
        wheel?.delegate = self
        wheel?.dataSource = self
        wheel?.isUserInteractionEnabled = false
        self.view.addSubview(wheel!)
        wheel?.center = view.center
        wheel?.frame.origin.y = view.frame.origin.y + 48 + 24
        wheel?.animateLanding = false
        
        view.addSubview(startButton)
        startButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 182.8,
                           width: 32, height: 32)
        startButton.layer.cornerRadius = 32 / 2
        startButton.centerX(inView: view)
        startButton.isUserInteractionEnabled = !selectedRestaurants.isEmpty
    }
    func configureResultView(valueRelateToResult value: Int){
        view.addSubview(resultView)
        resultView.setDimension(width: 280, height: 240)
        resultView.center(inView: view, yConstant: -100)
        
        resultView.restaurant = selectedRestaurants[value - 1]
        let blureffect = UIBlurEffect(style: .regular)
        let visualeffect = UIVisualEffectView(effect: blureffect)
        self.view.insertSubview(visualeffect, belowSubview: resultView)
        UIView.animate(withDuration: 2) {
            self.resultView.alpha = 1
            visualeffect.fit(inView: self.view)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    //MARK: - Selectors
    @objc func handleStartButtonTapped(){
        wheel?.manualRotation(aCircleTime: 0.75)
        let resultNumber = Int.random(in: 1...selectedRestaurants.count)
        wheel?.setTarget(section: resultNumber)
        startButton.isHidden = true
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
            self.wheel?.stop()
        }
    }
}
//MARK: - LuckyWheelDelegate, LuckyWheelDataSource
extension ActionViewController : LuckyWheelDelegate, LuckyWheelDataSource {
    func wheelDidChangeValue(_ newValue: Int) {
        configureResultView(valueRelateToResult: newValue)
    }
    func numberOfSections() -> Int {
        if selectedRestaurants.count == 0 {
            return 1
        }
        return selectedRestaurants.count * 2
    }
    
    func itemsForSections() -> [WheelItem] {
        let item = WheelItem(title: "", titleColor: .customblack, itemColor: .pale)
        guard let viewModel = viewModel else { return [item]}
        return viewModel.itemForSection
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
        optionImageView.af.setImage(withURL: restaurant.imageUrl)
        
    }
}
