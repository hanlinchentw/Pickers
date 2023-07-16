//
//  ExploreMainViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

final class ExploreMainViewController: UIViewController {
	// MARK: - Property
	let listViewController: FeedViewController
	let mapViewController: MapViewController
	let searchViewController: ExploreSearchViewController
	var mapSwitchButton = with(UIButton()) {
		$0.backgroundColor = .black
		$0.setImage(UIImage(systemName: "map"), for: .normal)
		$0.setTitle("Map", for: .normal)
		$0.layer.cornerRadius = 10
	}
	let viewModel: ExploreViewModel
	private var bottomSheetView: SlidingSheetView!
	weak var coordinator: ExploreCoordinator?
	
	static let FILTER_VIEW_HEIGHT: CGFloat = 200
	// MARK: - Lifecycle
	init(viewModel: ExploreViewModel) {
		self.viewModel = viewModel
		self.listViewController = FeedViewController(viewModel: viewModel)
		self.mapViewController = MapViewController(viewModel: viewModel)
		self.searchViewController = ExploreSearchViewController()
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
		self.view.sendSubviewToBack(bottomSheetView)
		self.view.sendSubviewToBack(mapViewController.view)
		self.view.bringSubviewToFront(searchViewController.view)
//		viewModel.fetch()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
		self.navigationController?.navigationBar.isTranslucent = true
		self.tabBarController?.tabBar.isHidden = true
	}
	
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
		searchViewController.view.setDimension(height: Self.FILTER_VIEW_HEIGHT)
	}
	
	func setupMapSwitchButton() {
		view.addSubview(mapSwitchButton)
		mapSwitchButton.centerX(inView: view)
		mapSwitchButton.anchor(bottom: view.bottomAnchor, paddingBottom: 120)
		mapSwitchButton.setDimension(width: 100, height: 20)

		mapSwitchButton.addTarget(self, action: #selector(didTapMapSwitchButton), for: .touchUpInside)
	}
	
	@objc func didTapMapSwitchButton() {
		bottomSheetView.moveToPosition(.bottom())
	}
}

// MARK: - BottomSheet
extension ExploreMainViewController {
	var bottomSheetHeightOnTop: CGFloat {
		UIScreen.main.bounds.height - Self.FILTER_VIEW_HEIGHT - 25
	}

	var bottomSheetHeightOnBottom: CGFloat {
		88
	}
	
	private func setupBottomSheet() {
		let configuration = SlidingSheetView.Config(
			contentView: listViewController,
			parentViewController: self,
			initialPosition: .top(bottomSheetHeightOnTop),
			allowedPositions: [
				.top(bottomSheetHeightOnTop),
				.bottom(bottomSheetHeightOnBottom)
			],
			showPullIndicator: true,
			isDismissable: false
		)

		self.bottomSheetView = SlidingSheetView(config: configuration)
		self.bottomSheetView.delegate = self

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

// MARK: - MapsController + SlidingSheetViewDelegate

extension ExploreMainViewController: SlidingSheetViewDelegate {
	
	public func slidingSheetViewScrollViewDidChangeOffset(_ view: SlidingSheetView, scrollView: UIScrollView, offset: CGPoint) {
	}
	
	public func slidingSheetView(_ view: SlidingSheetView, heightDidChange height: CGFloat) {
		listViewController.collectionView.collectionViewLayout.invalidateLayout()

		let x = height - bottomSheetHeightOnBottom
		let y = bottomSheetHeightOnTop - bottomSheetHeightOnBottom
		let ratio = x/y
		NotificationCenter.default.post(name: .exploreSlidingSheetHeightDidChange, object: nil, userInfo: ["height": height, "ratio": ratio])
	}
	
	public func slidingSheetView(_ view: SlidingSheetView, willMoveTo position: SlidingSheetView.Position) {

	}
	
	public func slidingSheetView(_ view: SlidingSheetView,
															 didMoveFromPosition position: SlidingSheetView.Position?,
															 toPosition: SlidingSheetView.Position) {
		mapSwitchButton.isHidden = !toPosition.isTop
		view.setAsAnchored(!toPosition.isTop)
		view.panGesture.isEnabled = !toPosition.isTop
	}
	
	public func slidingSheetViewRequestForDismission(_ view: SlidingSheetView) {
	}
}
