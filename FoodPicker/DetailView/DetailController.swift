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

@MainActor
class DetailController : UICollectionViewController {
  //MARK: - Prorperties
  weak var delegate: DetailControllerDelegate?
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
  var viewModel: DetailViewModel
  //MARK: - Lifecycle
  init(id: String) {
    self.viewModel = DetailViewModel(restaurantId: id)
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureCollectionView()
    bindSelectButton()
    bindCollectionView()
    viewModel.refresh()
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
    viewModel.$isSelected.sink { isSelected in
      let imageName = isSelected ? "btnFloatingAddSelectedXshadow" : "btnFloatingAddNoShadow"
      self.addButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
    }.store(in: &set)
  }

  func bindCollectionView() {
    viewModel.$detail
      .combineLatest(viewModel.$isLiked, viewModel.$isSelected, viewModel.$isExpanded)
      .sink { _, _, _, _ in
        print("bindCollectionView.reload")
        self.collectionView.reloadData()
      }
      .store(in: &set)
  }
  //MARK: - Selectors
  @objc func handleSelectButtonTapped(){
    self.viewModel.selectButtonTapped()
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
}
extension DetailController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return DetailConfig.allCases.count
  }

  @MainActor
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellIdentifier, for: indexPath) as! DetailCell
    guard let detail = viewModel.detail else { return cell }
    let config = DetailConfig(rawValue: indexPath.row)!
    var presenter: DetailRowPresenter = DetailRowPresenterMapper.mapPresenterFromDetailConfig(config, detail: detail, isExpanded: viewModel.isExpanded)
    presenter.delegate = self
    cell.presenter = presenter
    cell.isExpanded = self.viewModel.isExpanded
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: headerIdentifier, for: indexPath) as! DetailHeader
    header.delegate = self
    let viewModel = DetailHeaderPresenter( isLiked: self.viewModel.isLiked, detail: viewModel.detail)
    header.presenter = viewModel
    return header
  }
}
extension DetailController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if self.viewModel.isExpanded, indexPath.row == 1 {
      return  CGSize(width: collectionView.frame.width, height: 262)
    }
    return  CGSize(width: collectionView.frame.width, height: 72)

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
    self.viewModel.likedButtonTapped()
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
  func didTapActionButton(_ config: DetailConfig) {
    guard let detail = viewModel.detail else { return }
    switch config {
    case .main, .phone: break
    case .businessHour:
      viewModel.isExpanded.toggle()
      break
    case .address:
      MKMapView.openMapForPlace(name: detail.name, coordinate: detail.coordinates)
      break
    }
  }
}
