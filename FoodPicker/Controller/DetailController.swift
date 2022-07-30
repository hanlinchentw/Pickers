//
//  DetailController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/19.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Alamofire
import AlamofireImage

private let detailCellIdentifier = "DetailCell"
private let headerIdentifier = "DetailHeader"



class DetailController : UICollectionViewController {
    //MARK: - Prorperties
    var restaurant : Restaurant { didSet { self.collectionView.reloadData() } }
    weak var delegate: DetailControllerDelegate?
    private var isExpanded = false
    private lazy var addButton : UIButton = {
        let button = UIButton(type: .system)
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.customblack.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        
        let imageName = restaurant.isSelected ? "btnFloatingAddSelectedXshadow" : "btnFloatingAddNoShadow"
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSelectButtonTapped), for: .touchUpInside)
        return button
    }()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionView()
        self.tabBarController?.tabBar.isHidden = true
    }
    //MARK: - API
    func fetchDetail(success: @escaping()->Void, failure: @escaping(Error)->Void){
        NetworkService.shared.fetchDetail(id: restaurant.restaurantID) { [weak self] (detail, error) in
            if let detail = detail {
                self?.restaurant.details = detail
                self?.collectionView.reloadData()
                success()
            }else {
                failure(error!)
            }
        }
    }
    //MARK: - Selectors
    @objc func handleSelectButtonTapped(){
        restaurant.isSelected.toggle()
        delegate?.didSelectRestaurant(restaurant: restaurant)
        let imageName = restaurant.isSelected ? "btnFloatingAddSelectedXshadow" : "btnFloatingAddNoShadow"
        addButton.changeImageButtonWithBounceAnimation(changeTo: imageName)
    }
    //MARK: - Helpers
    func configureCollectionView(){
        collectionView.backgroundColor = .backgroundColor
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: detailCellIdentifier)
        collectionView.register(DetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false

        let inset = UIApplication.shared.windows[0].safeAreaInsets.top
        collectionView.contentInset = UIEdgeInsets(top: -inset, left: 0, bottom: 100, right: 0)
    }
    func configureUI(){
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        view.addSubview(addButton)
        addButton.anchor(right:view.rightAnchor, bottom: view.bottomAnchor,
                         paddingRight: 16, paddingBottom: 30,width: 56, height: 56)
    }
    func configureUIForResult(){
        self.addButton.isHidden = true
    }
    func openMapForPlace(name: String, coordinate: CLLocationCoordinate2D) {
        let regionDistance:CLLocationDistance = 3000
        let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
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
        let viewModel = DetailCellViewModel(restaurant: restaurant, config: config, isExpanded: isExpanded)
        cell.config = config
        cell.viewModel = viewModel
        cell.delegate = self
        cell.isExpanded = self.isExpanded
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: headerIdentifier, for: indexPath) as! DetailHeader
        header.delegate = self
        
        let viewModel = DetailHeaderViewModel(restaurant: restaurant)
        header.viewModel = viewModel
        return header
    }
}
extension DetailController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isExpanded, indexPath.row == 1{
            return  CGSize(width: collectionView.frame.width, height: 262)
        }
        let config = RestaurantDetail(rawValue: indexPath.row)
        let viewModel = DetailCellViewModel(restaurant: restaurant, config: config, isExpanded: isExpanded)
        return  CGSize(width: collectionView.frame.width, height: viewModel.heightForEachCell)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = 300 * view.heightMultiplier * view.iPhoneSEMutiplier
        return CGSize(width: collectionView.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
//MARK: - DetailHeaderDelegate
extension DetailController : DetailHeaderDelegate {
    func handleDismissDetailPage() {
        delegate?.willPopViewController(self)
    }
    func handleLikeRestaurant() {
        restaurant.isLiked.toggle()
        delegate?.didLikeRestaurant(restaurant: restaurant)
        self.collectionView.reloadData()
    }
    func handleShareRestaurant() {
        let imageView = UIImageView()
        imageView.af.setImage(withURL: restaurant.imageUrl)
        guard let image = imageView.image else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [image, restaurant.name], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}
//MARK: - DetailCellDelegate
extension DetailController: DetailCellDelegate {
    func didTapMapOption(name: String, coordinate: CLLocationCoordinate2D) {
        openMapForPlace(name: name, coordinate: coordinate)
    }
    func shouldCellExpand(_ isExpanded: Bool, config: RestaurantDetail) {
        print("DEBUG: Expand...\(isExpanded)")
        if config == .businessHour {
            self.isExpanded = isExpanded
            self.collectionView.reloadData()
        }
    }
}
