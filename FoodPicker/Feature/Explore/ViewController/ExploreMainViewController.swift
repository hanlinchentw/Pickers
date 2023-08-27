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
	let viewModel: ExploreViewModel
	private var bottomSheetView: SlidingSheetView!
	static let FILTER_VIEW_HEIGHT: CGFloat = 170
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
		view.sendSubviewToBack(bottomSheetView)
		view.sendSubviewToBack(mapViewController.view)
		view.bringSubviewToFront(searchViewController.view)
		viewModel.fetch()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
		navigationController?.navigationBar.isTranslucent = true
		tabBarController?.tabBar.isHidden = true
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
		mapSwitchButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 64)
		mapSwitchButton.setDimension(width: 90, height: 32)

		mapSwitchButton.addTarget(self, action: #selector(didTapMapSwitchButton), for: .touchUpInside)
	}
	
	@objc func didTapMapSwitchButton() {
		bottomSheetView.moveToPosition(.bottom())
		bottomSheetView.resetContentOffset()
		bottomSheetView.contentView.presentedView.alpha = 0
	}
	
	func refreshView() {
		listViewController.updateView()
	}
}

// MARK: - BottomSheet
extension ExploreMainViewController {
	var bottomSheetHeightOnTop: CGFloat {
		UIScreen.main.bounds.height - Self.FILTER_VIEW_HEIGHT + 25
	}

	var bottomSheetHeightOnBottom: CGFloat {
		72
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

// MARK: - SlidingSheetViewDelegate
extension ExploreMainViewController: SlidingSheetViewDelegate {
	public func slidingSheetViewScrollViewDidChangeOffset(_ view: SlidingSheetView, scrollView: UIScrollView, offset: CGPoint) {}
	
	public func slidingSheetView(_ view: SlidingSheetView, heightDidChange height: CGFloat) {
		listViewController.collectionView.collectionViewLayout.invalidateLayout()
		let x = height - bottomSheetHeightOnBottom
		let y = bottomSheetHeightOnTop - bottomSheetHeightOnBottom
		let ratio = x/y
		NotificationCenter.default.post(name: .exploreSlidingSheetHeightDidChange, object: nil, userInfo: ["height": height, "ratio": ratio])
	}
	
	public func slidingSheetView(_ view: SlidingSheetView, willMoveTo position: SlidingSheetView.Position) {
		if position.isTop {
			UIView.animate(withDuration: 0.3) {
				view.contentView.presentedView.alpha = 1
			}
		}
	}
	
	public func slidingSheetView(_ view: SlidingSheetView,
															 didMoveFromPosition position: SlidingSheetView.Position?,
															 toPosition: SlidingSheetView.Position) {
		mapSwitchButton.isHidden = !toPosition.isTop
		view.setAsAnchored(!toPosition.isTop)
		view.panGesture.isEnabled = !toPosition.isTop
	}

	public func slidingSheetViewRequestForDismission(_ view: SlidingSheetView) {}
	
	public func slidingSheetControllerWillStartDragging() {
		mapSwitchButtonVisibilityTimeout?.invalidate()
		hideMapSwitchButton()
	}

	func slidingSheetControllerWillBeginDecelerating() {
		mapSwitchButtonVisibilityTimeout = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
			self.showMapSwitchButton()
		})
	}

	func slidingSheetControllerWillEndDragging() {
		mapSwitchButtonVisibilityTimeout = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
			self.showMapSwitchButton()
		})
	}

	func showMapSwitchButton() {
		self.mapSwitchButton.isHidden = false
		UIView.animate(withDuration: 0.3) {
			self.mapSwitchButton.alpha = 1
		}

	}

	func hideMapSwitchButton() {
		UIView.animate(withDuration: 0.3) {
			self.mapSwitchButton.alpha = 0
		} completion: { _ in
			self.mapSwitchButton.isHidden = true
		}
	}
}
