//
//  DetailController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/19.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit


private let detailCellIdentifier = "DetailCell"
private let headerIdentifier = "DetailHeader"

class DetailController : UICollectionViewController {
    //MARK: - Prorperties
    private var restaurant : Restaurant { didSet { self.collectionView.reloadData() } }
    private var isExpanded = false
    private lazy var addButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnFloatingbtnAddToSpinL")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
   
    //MARK: - Lifecycle
    init(restaurant:Restaurant) {
        self.restaurant = restaurant
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - API
    func fetchDetail(){
        NetworkService.shared.fetchDetail(id: restaurant.restaurantID) { (detail) in
            self.restaurant.details = detail
        }
    }
    //MARK: - Helpers
    func configureUI(){
        collectionView.backgroundColor = .backgroundColor
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: detailCellIdentifier)
        collectionView.register(DetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        view.addSubview(addButton)
        addButton.anchor(right:view.rightAnchor, bottom: view.bottomAnchor,
                         paddingRight: 16, paddingBottom: 30)
    }
}
extension DetailController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RestaurantDetail.allCases.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellIdentifier, for: indexPath)
        as! DetailCell
        
        let config = RestaurantDetail(rawValue: indexPath.row)
        let viewModel = DetailViewModel(restaurant: restaurant, config: config, isExpanded: isExpanded)
        cell.config = config
        cell.viewModel = viewModel
        cell.delegate = self
        cell.isExpanded = self.isExpanded
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: headerIdentifier, for: indexPath) as! DetailHeader
        header.delegate = self
        let config = RestaurantDetail(rawValue: indexPath.row)
        let viewModel = DetailViewModel(restaurant: restaurant, config: config, isExpanded: isExpanded)
        guard let urls =  viewModel.imageUrl else { return  header}
        header.imageUrl = urls
        return header
    }
}
extension DetailController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isExpanded, indexPath.row == 1{
            return  CGSize(width: collectionView.frame.width, height: 262)
        }
        let config = RestaurantDetail(rawValue: indexPath.row)
        let viewModel = DetailViewModel(restaurant: restaurant, config: config, isExpanded: isExpanded)
        return  CGSize(width: collectionView.frame.width, height: viewModel.heightForEachCell)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
//MARK: - DetailHeaderDelegate
extension DetailController : DetailHeaderDelegate {
    func handleDismissDetailPage() {
        self.navigationController?.popViewController(animated: true)
        print("DEBUG: Did tapped in controller")
    }
    func handleLikeRestaurant() {
        print("DEBUG: Like a restaurnat..")
    }
    func handleShareRestaurant() {
        print("DEBUG: Shard a Restaurant")
    }
}
//MARK: - DetailCellDelegate
extension DetailController: DetailCellDelegate {
    func shouldCellExpand(_ isExpanded: Bool, config: RestaurantDetail) {
        print("DEBUG: Expand...\(isExpanded)")
        if config == .businessHour {
            self.isExpanded = isExpanded
            self.collectionView.reloadData()
        }
    }
}
