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
	private let searchBarView = ExploreSearchBarView()
	private let segmentedView = JXSegmentedView()
	var segmentedDataSource: JXSegmentedTitleDataSource?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSearchBarView()
		setupSegmentedView()
		view.backgroundColor = .white
	}
	
	func setupSearchBarView() {
		view.addSubview(searchBarView)
		searchBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
		searchBarView.anchor(left: view.leftAnchor, paddingLeft: 28)
		searchBarView.anchor(right: view.rightAnchor, paddingRight: 28)
	}
	
	func setupSegmentedView() {
		segmentedDataSource = JXSegmentedTitleDataSource()

		segmentedDataSource?.titles = ["Top rating", "Popular", "Nearby"]
		segmentedDataSource?.titleNormalFont = .arial14MT
		segmentedDataSource?.titleSelectedFont = .arial14MT
		segmentedDataSource?.isItemSpacingAverageEnabled = false
		segmentedDataSource?.reloadData(selectedIndex: 0)
		segmentedDataSource?.titleNormalColor = .black
		segmentedDataSource?.titleSelectedColor = .black

		view.addSubview(segmentedView)
		segmentedView.delegate = self
		segmentedView.dataSource = segmentedDataSource
		segmentedView.anchor(top: searchBarView.bottomAnchor, paddingTop: 12)
		segmentedView.anchor(left: view.leftAnchor)
		segmentedView.anchor(right: view.rightAnchor)
		segmentedView.setDimension(height: 44 )

		let indicator = JXSegmentedIndicatorLineView()
		indicator.lineStyle = .lengthenOffset
		indicator.indicatorColor = .black
		indicator.indicatorHeight = 1.5
		segmentedView.indicators = [indicator]
	}
}

extension ExploreSearchViewController: JXSegmentedViewDelegate {
		func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
				navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
		}
}
