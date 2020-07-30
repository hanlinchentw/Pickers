//
//  ActionController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import iOSLuckyWheel

private let selectedIdentifier = "FavoriteCell"

class ActionViewController: UIViewController {
    //MARK: - Properties
    var selectedRestaurants = [Restaurant]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var wheel : LuckyWheel?
    
    var viewModel : LuckyWheelViewModel? {
        didSet{
            wheel?.removeFromSuperview()
            configureWheel()
        }
    }
    
    private var startButton  : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleStartButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var collectionView : UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical
           let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
           cv.backgroundColor = .backgroundColor
           return cv
       }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
        configureWheel()
        configureCollectionView()

    }
    //MARK: - Helpers
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
        startButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 182.8)
        startButton.centerX(inView: view)
        startButton.isUserInteractionEnabled = !selectedRestaurants.isEmpty
    }
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: selectedIdentifier)
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left:view.leftAnchor,
                              right: view.rightAnchor,bottom: view.bottomAnchor,
                              paddingTop: 408)
    }
    
    func configure(){
        wheel = LuckyWheel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 40 , height: 365.6))
        wheel?.delegate = self
        wheel?.dataSource = self
        wheel?.isUserInteractionEnabled = false
        self.view.addSubview(wheel!)
        wheel?.center = view.center
        wheel?.frame.origin.y = view.frame.origin.y + 48 + 24
        wheel?.animateLanding = false
        
        
    }
    //MARK: - Selectors
    @objc func handleStartButtonTapped(){
        wheel?.manualRotation(aCircleTime: 0.1)
        wheel?.setTarget(section: Int.random(in: 1...selectedRestaurants.count))
        startButton.isHidden = true
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            self.wheel?.stop()
        }
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ActionViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedRestaurants.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectedIdentifier, for: indexPath)
        as! FavoriteCell
        cell.restaurant = selectedRestaurants[indexPath.row]
        return cell
    }
}
extension ActionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-32 , height: 88)
    }
}
//MARK: - LuckyWheelDelegate, LuckyWheelDataSource
extension ActionViewController : LuckyWheelDelegate, LuckyWheelDataSource {
    func wheelDidChangeValue(_ newValue: Int) {
        print(newValue)
    }
    func numberOfSections() -> Int {
        if selectedRestaurants.count == 0 {
            return 1
        }
        return selectedRestaurants.count * 2
    }
    
    func itemsForSections() -> [WheelItem] {
        let item = WheelItem(title: "", titleColor: .black, itemColor: .pale)
        guard let viewModel = viewModel else { return [item]}
        return viewModel.itemForSection
    }
}
