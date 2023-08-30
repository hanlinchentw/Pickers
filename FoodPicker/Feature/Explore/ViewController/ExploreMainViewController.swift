//
//  ExploreMainViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

final class ExploreMainViewController: UIViewController, ExploreView {
	struct Constant {
		static let filterHeight: CGFloat = 170
		static let bottomSheetBottomHeight: CGFloat = 72
	}

	// MARK: - Property
	let listView: PlaceListView
	let mapViewController: MapViewController
	let searchViewController: ExploreSearchViewController
	var mapSwitchButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "map.fill"), for: .normal)
		button.semanticContentAttribute = .forceRightToLeft
		button.setTitle("Map", for: .normal)
		button.titleLabel?.font = .arial14MT
		button.backgroundColor = .black
		button.tintColor = .white
		button.layer.cornerRadius = 16
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
		return button
	}()
	var mapSwitchButtonVisibilityTimeout: Timer?
	let presenter: ExplorePresenting
	private var bottomSheetView: PlaceListBottomSheetView!
	// MARK: - Lifecycle
	init(presenter: ExplorePresenting) {
		self.listView = PlaceListView()
		self.mapViewController = MapViewController()
		self.searchViewController = ExploreSearchViewController()
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupMap()
		setupSearch()
		setupBottomSheet()
		setupMapSwitchButton()
		bottomSheetView?.setupLayout(animated: false)
		view.sendSubviewToBack(bottomSheetView)
		view.sendSubviewToBack(mapViewController.view)
		view.bringSubviewToFront(searchViewController.view)
		presenter.onViewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
		navigationController?.navigationBar.isTranslucent = true
		tabBarController?.tabBar.isHidden = true
	}
	
	@objc func didTapMapSwitchButton() {
		bottomSheetView.moveToPosition(.bottom())
		bottomSheetView.resetContentOffset()
		bottomSheetView.contentView.presentedView.alpha = 0
	}
	
	func refreshView() {
		listView.update()
	}
	
	func didChangePlaceStatus() {
		refreshView()
	}
	
	func didFetchPlace() {
		refreshView()
	}
}

// MARK: - PlaceListViewDelegate
extension ExploreMainViewController: PlaceListViewDelegate {
	func placesCount() -> Int {
		presenter.count()
	}
	
	func viewModel(atIndex index: Int) -> PlaceViewModel {
		presenter.viewModel(index: index)
	}
	
	func didTapAddButton(viewModel: PlaceViewModel) {
		presenter.didSelectPlace(viewModel: viewModel)
	}
}

// MARK: - PlaceListBottomSheetViewDelegate
extension ExploreMainViewController: PlaceListBottomSheetViewDelegate {
	func didMove(toPosition: SlidingSheetView.Position) {
		toPosition.isTop ? self.mapSwitchButton.showWithAnimation() : self.mapSwitchButton.hideWithAnimation()
	}
	
	func didStartDragging() {
		mapSwitchButtonVisibilityTimeout?.invalidate()
		self.mapSwitchButton.hideWithAnimation()
	}
	
	func didStopDragging() {
		mapSwitchButtonVisibilityTimeout = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
			self.mapSwitchButton.showWithAnimation()
		})
	}
}

// MARK: - UI Layout
extension ExploreMainViewController {
	func setupMap() {
		addChild(mapViewController)
		view.addSubview(mapViewController.view)
		mapViewController.view.fit(inView: view)
	}
	
	func setupSearch() {
		addChild(searchViewController)
		view.addSubview(searchViewController.view)
		searchViewController.view.anchor(top: view.topAnchor)
		searchViewController.view.anchor(left: view.leftAnchor)
		searchViewController.view.anchor(right: view.rightAnchor)
		searchViewController.view.setDimension(height: Constant.filterHeight)
	}
	
	func setupMapSwitchButton() {
		view.addSubview(mapSwitchButton)
		mapSwitchButton.centerX(inView: view)
		mapSwitchButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 64)
		mapSwitchButton.setDimension(width: 90, height: 32)

		mapSwitchButton.addTarget(self, action: #selector(didTapMapSwitchButton), for: .touchUpInside)
	}
	
	func setupBottomSheet() {
		listView.delegate = self
		let bottomSheetHeightOnTop = UIScreen.main.bounds.height - Constant.filterHeight + 25
		self.bottomSheetView = PlaceListBottomSheetView(
			contentView: listView,
			parentViewController: self,
			maximumHeight: bottomSheetHeightOnTop,
			minimumHeight: Constant.bottomSheetBottomHeight
		)
		self.bottomSheetView.sheetDelegate = self
		view.addSubview(bottomSheetView!)
		bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		bottomSheetView.backgroundColor = .white
	}
}
