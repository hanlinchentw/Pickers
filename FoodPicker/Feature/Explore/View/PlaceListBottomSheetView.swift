//
//  PlaceListBottomSheetView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

protocol PlaceListBottomSheetViewDelegate: AnyObject {
	func didMove(toPosition: SlidingSheetView.Position)
	func didStartDragging()
	func didStopDragging()
}

extension PlaceListView: SlideSheetPresented {
	var presentedView: UIView {
		self
	}
	var scrollView: UIScrollView? {
		collectionView
	}
}

final class PlaceListBottomSheetView: SlidingSheetView {
	weak var sheetDelegate: PlaceListBottomSheetViewDelegate?

	var maximumHeight: CGFloat

	var minimumHeight: CGFloat

	init(
		contentView: SlideSheetPresented,
		parentViewController: UIViewController,
		maximumHeight: CGFloat,
		minimumHeight: CGFloat
	) {
		let configuration = SlidingSheetView.Config(
			contentView: contentView,
			parentViewController: parentViewController,
			initialPosition: .top(maximumHeight),
			allowedPositions: [
				.top(maximumHeight),
				.bottom(minimumHeight)
			],
			showPullIndicator: true,
			isDismissable: false
		)
		self.maximumHeight = maximumHeight
		self.minimumHeight = minimumHeight
		super.init(config: configuration)
		self.delegate = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension PlaceListBottomSheetView: SlidingSheetViewDelegate {
	func slidingSheetViewScrollViewDidChangeOffset(_ view: SlidingSheetView, scrollView: UIScrollView, offset: CGPoint) {}
	
	func slidingSheetView(_ view: SlidingSheetView, heightDidChange height: CGFloat) {
		let x = height - minimumHeight
		let y = maximumHeight - minimumHeight
		let ratio = x/y
		NotificationCenter.default.post(name: .exploreSlidingSheetHeightDidChange, object: nil, userInfo: ["height": height, "ratio": ratio])
	}
	
	func slidingSheetView(_ view: SlidingSheetView, willMoveTo position: SlidingSheetView.Position) {
		if position.isTop {
			view.contentView.presentedView.showWithAnimation()
		}
	}
	
	func slidingSheetView(_ view: SlidingSheetView,
															 didMoveFromPosition position: SlidingSheetView.Position?,
															 toPosition: SlidingSheetView.Position) {
		view.setAsAnchored(!toPosition.isTop)
		sheetDelegate?.didMove(toPosition: toPosition)
	}

	func slidingSheetViewRequestForDismission(_ view: SlidingSheetView) {}
	
	func slidingSheetControllerWillStartDragging() {
		sheetDelegate?.didStartDragging()
	}

	func slidingSheetControllerWillBeginDecelerating() {
		sheetDelegate?.didStopDragging()
	}

	func slidingSheetControllerWillEndDragging() {
		sheetDelegate?.didStopDragging()
	}
}
