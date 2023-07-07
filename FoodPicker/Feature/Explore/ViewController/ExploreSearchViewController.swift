//
//  ExploreSearchViewController	.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/7.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import JXSegmentedView

class ExploreSearchViewController: UIViewController {
	private let searchBarView = UIView()
	private let segmentedView = JXSegmentedView()
	var segmentedDataSource: JXSegmentedTitleDataSource?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSegmentedView()
		view.backgroundColor = .white
	}
	
	func setupSegmentedView() {
		segmentedDataSource = JXSegmentedTitleDataSource()

		segmentedDataSource?.titles = ["Top rating", "Popular", "Nearby"]

		segmentedDataSource?.isItemSpacingAverageEnabled = false
		segmentedDataSource?.reloadData(selectedIndex: 0)

		view.addSubview(segmentedView)
		segmentedView.delegate = self
		segmentedView.dataSource = segmentedDataSource
		segmentedView.anchor(bottom: view.bottomAnchor)
		segmentedView.anchor(left: view.leftAnchor)
		segmentedView.anchor(right: view.rightAnchor)
		segmentedView.setDimension(height: 56)

		let indicator = JXSegmentedIndicatorLineView()
		indicator.lineStyle = .lengthenOffset
		segmentedView.indicators = [indicator]
	}
}

extension ExploreSearchViewController: JXSegmentedViewDelegate {
		func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
				navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
		}
}
