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

	let viewModel: ExploreViewModel
	private var bottomSheetView: SlidingSheetView!
	weak var coordinator: ExploreCoordinator?
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
		searchViewController.view.setDimension(height: 200)
	}
}

extension ExploreMainViewController {
	private func topHeightMargin() -> CGFloat {
		let filtersViewHeight: CGFloat = 200
		return filtersViewHeight - 25
	}
	
	private func setupBottomSheet() {
		let initialPosition = SlidingSheetView.Position.top(UIScreen.main.bounds.height - topHeightMargin())
		let configuration = SlidingSheetView.Config(
			contentView: listViewController,
			parentViewController: self,
			initialPosition: initialPosition,
			allowedPositions: [
				initialPosition,
				.bottom(150)
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
	
	public func slidingSheetViewScrollViewDidChangeOffset(_ view: SlidingSheetView,
																												scrollView: UIScrollView,
																												offset: CGPoint) {
		
		let threshold: CGFloat = -40
		if offset.y < threshold {
			view.moveToPosition(.bottom(), duration: 1)
		}
	}
	
	public func slidingSheetView(_ view: SlidingSheetView,
															 heightDidChange height: CGFloat) {
		
	}
	
	public func slidingSheetView(_ view: SlidingSheetView,
															 willMoveTo position: SlidingSheetView.Position) {
		
	}
	
	public func slidingSheetView(_ view: SlidingSheetView,
															 didMoveFromPosition position: SlidingSheetView.Position?,
															 toPosition: SlidingSheetView.Position) {
		
		// Modify appearance when fully expanded
		view.setAsAnchored(!toPosition.isTop)
		
		// Disable the pan gesture on top in order to avoid collpasing the sheet while moving inside table cells.
		view.panGesture.isEnabled = !toPosition.isTop
//		
		// Disable scrolling inside the table when collapsed.
		listViewController.scrollView?.isUserInteractionEnabled = toPosition.isTop
		listViewController.collectionView.reloadData()
	}
	
	public func slidingSheetViewRequestForDismission(_ view: SlidingSheetView) {
		
	}
}
