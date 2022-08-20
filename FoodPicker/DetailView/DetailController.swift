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
import Combine

private let detailCellIdentifier = "DetailCell"
private let headerIdentifier = "DetailHeader"

class DetailController : UICollectionViewController {
  //MARK: - Prorperties
  weak var delegate: DetailControllerDelegate?
  private var detail: Detail? { didSet { collectionView.reloadData() }}
  private var isExpanded = false
  private lazy var addButton : UIButton = {
    let button = UIButton(type: .system)
    button.layer.masksToBounds = false
    button.layer.shadowColor = UIColor.customblack.cgColor
    button.layer.shadowOpacity = 0.3
    button.layer.shadowOffset = CGSize(width: 0, height: 1)
    button.layer.shadowRadius = 3
    button.addTarget(self, action: #selector(handleSelectButtonTapped), for: .touchUpInside)
    return button
  }()

  var set = Set<AnyCancellable>()
  @Published var isSelected: Bool
  @Published var isLiked: Bool
  //MARK: - Lifecycle
  init(id: String) {
    @Inject var selectedCoreService: SelectedCoreService
    @Inject var likedCoreService: LikedCoreService

    self.isSelected = try! selectedCoreService.exists(id: id, in: CoreDataManager.sharedInstance.managedObjectContext)
    self.isLiked = try! likedCoreService.exists(id: id, in: CoreDataManager.sharedInstance.managedObjectContext)

    super.init(collectionViewLayout: UICollectionViewFlowLayout())
    fetchDetail(id: id)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureCollectionView()
    bindSelectButton()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    self.tabBarController?.tabBar.isHidden = true
    self.navigationController?.navigationBar.isTranslucent = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isTranslucent = false
  }
  // MARK: - Binding
  func bindSelectButton() {
    $isSelected.sink { isSelected in
      let imageName = isSelected ? "btnFloatingAddSelectedXshadow" : "btnFloatingAddNoShadow"
      self.addButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
    }.store(in: &set)
  }
  // MARK: - BusinessService
  func fetchDetail(id: String) {
    MBProgressHUDHelper.showLoadingAnimation()
    Task {
      do {
        let detail = try await BusinessService.fetchDetail(id: id)
        self.detail = detail
        MBProgressHUDHelper.hideLoadingAnimation()
      } catch {
        print("fetchDetail.failed >>> \(error.localizedDescription)")
        MBProgressHUDHelper.hideLoadingAnimation()
      }
    }
  }
  //MARK: - Selectors
  @objc func handleSelectButtonTapped(){
    self.isSelected.toggle()
  }
  //MARK: - Helpers
  func configureCollectionView(){
    collectionView.backgroundColor = .backgroundColor
    collectionView.register(DetailCell.self, forCellWithReuseIdentifier: detailCellIdentifier)
    collectionView.register(DetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.bounces = false

    collectionView.contentInset = UIEdgeInsets(top: -SafeAreaUtils.top, left: 0, bottom: 100, right: 0)
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
    let regionDistance: CLLocationDistance = 3000
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
    return DetailConfig.allCases.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellIdentifier, for: indexPath)
    guard let detail = detail, let cell = cell as? DetailCell else {
      return .init()
    }
    let config = DetailConfig(rawValue: indexPath.row)
    let viewModel = DetailCellViewModel(detail: detail, config: config, isExpanded: isExpanded)
    cell.config = config
    cell.viewModel = viewModel
    cell.delegate = self
    cell.isExpanded = self.isExpanded
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: headerIdentifier, for: indexPath) as! DetailHeader
    header.delegate = self
    let viewModel = DetailHeaderViewModel( isLiked: self.isLiked, detail: detail)
    header.viewModel = viewModel
    return header
  }
}
extension DetailController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if isExpanded, indexPath.row == 1{
      return  CGSize(width: collectionView.frame.width, height: 262)
    }
    guard let detail = detail else {
      return CGSize(width: 0, height: 0)
    }
    let config = DetailConfig(rawValue: indexPath.row)
    let viewModel = DetailCellViewModel(detail: detail, config: config, isExpanded: isExpanded)
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
  @objc func handleDismissDetailPage() {
    delegate?.willPopViewController(self)
  }
  func handleLikeRestaurant() {
    self.isLiked.toggle()
    self.collectionView.reloadData()
  }
  func handleShareRestaurant() {
    let imageView = UIImageView()
    //    imageView.af.setImage(withURL: restaurant.imageUrl)
    guard let image = imageView.image else { return }

    //    let activityViewController = UIActivityViewController(activityItems: [image, restaurant.name], applicationActivities: nil)
    //    self.present(activityViewController, animated: true, completion: nil)
  }
}
//MARK: - DetailCellDelegate
extension DetailController: DetailCellDelegate {
  func didTapMapOption(name: String, coordinate: CLLocationCoordinate2D) {
    MKMapView.openMapForPlace(name: name, coordinate: coordinate)
  }
  func shouldCellExpand(_ isExpanded: Bool, config: DetailConfig) {
    if config == .businessHour {
      self.isExpanded = isExpanded
      self.collectionView.reloadData()
    }
  }
}
