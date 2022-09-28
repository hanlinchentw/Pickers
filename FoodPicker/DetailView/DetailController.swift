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
import ImageSlideshow

private let detailCellIdentifier = "DetailCell"
private let headerIdentifier = "DetailHeader"

@MainActor
class DetailController : UICollectionViewController {
	//MARK: - Prorperties
	private var addButton = DetailAddButton()
	var viewModel: DetailViewModel
	var set = Set<AnyCancellable>()
	//MARK: - Lifecycle
	init(id: String) {
		self.viewModel = DetailViewModel(restaurantId: id)
		let layout = UICollectionViewFlowLayout()
		layout.headerReferenceSize = CGSize(width: UIScreen.screenWidth, height: 300)
		super.init(collectionViewLayout: layout)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
		configureAddButton()
		bindCollectionView()
		viewModel.refresh()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
		self.navigationController?.navigationBar.isTranslucent = true
	}
	// MARK: - Binding
	func bindCollectionView() {
		viewModel.$detail
			.combineLatest(viewModel.$isLiked)
			.sink { [weak self] _, _ in
				self?.collectionView.reloadData()
			}
			.store(in: &set)
		
		viewModel.$isExpanded
			.sink { [weak self] _ in
				self?.collectionView.reloadItems(at: [.init(row: 1, section: 0)])
			}
			.store(in: &set)
	}
	//MARK: - Helpers
	func configureCollectionView() {
		collectionView.backgroundColor = .backgroundColor
		collectionView.register(DetailCell.self, forCellWithReuseIdentifier: detailCellIdentifier)
		collectionView.register(DetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.setDimension(width: UIScreen.screenWidth, height: UIScreen.screenHeight + 1000)
		collectionView.contentInset = UIEdgeInsets(top: -SafeAreaUtils.top, left: 0, bottom: 100, right: 0)
	}
	
	func configureAddButton(){
		addButton.addTarget(self, action: #selector(handleSelectButtonTapped), for: .touchUpInside)
		
		view.addSubview(addButton)
		addButton.anchor(right:view.rightAnchor, bottom: view.bottomAnchor,
										 paddingRight: 16, paddingBottom: 30,width: 56, height: 56)
		
		viewModel.$isSelected
			.sink { [weak self] isSelected in
				let imageName = isSelected ? "btnFloatingAddSelectedXshadow" : "btnFloatingAddNoShadow"
				self?.addButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
			}.store(in: &set)
	}
	
	@objc func handleSelectButtonTapped(){
		viewModel.selectButtonTapped()
	}
}

@MainActor
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
	
	@MainActor
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: headerIdentifier, for: indexPath) as! DetailHeader
		let presenter = DetailHeaderPresenter(isLiked: self.viewModel.isLiked, detail: viewModel.detail)
		presenter.delegate = self
		header.presenter = presenter
		return header
	}
}
extension DetailController : UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if self.viewModel.isExpanded, indexPath.row == 1 {
			return  CGSize(width: collectionView.frame.width, height: 280)
		}
		return  CGSize(width: collectionView.frame.width, height: 88)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 4
	}
}
//MARK: - DetailHeaderDelegate
extension DetailController : DetailHeaderDelegate {
	@objc func handleDismissDetailPage() {
		navigationController?.popViewController(animated: true)
	}
	
	func handleLikeRestaurant() {
		self.viewModel.likeButtonTapped()
	}
	
	func handleShareRestaurant() {
		self.viewModel.shareButtonTapped()
	}
	
	func pushToSlideShowVC(photos: Array<AlamofireSource>) {
		let slideShow = SlideShowViewController(photos: photos)
		slideShow.modalTransitionStyle = .crossDissolve
		slideShow.modalPresentationStyle = .fullScreen
		self.present(slideShow, animated: true)
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
