//
//  ListViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import Combine

final class FeedViewController: UIViewController {
	var collectionView: UICollectionView!
	let viewModel: ExploreViewModel

	var cancellableSet = Set<AnyCancellable>()

	init(viewModel: ExploreViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
		viewModel.viewObjectsPublisher
			.receive(on: RunLoop.main)
			.sink { _ in
				self.collectionView?.reloadData()
			}
			.store(in: &cancellableSet)
	}
}

extension FeedViewController: UICollectionViewDelegate {}

extension FeedViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.viewObjects.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FeedCell.self), for: indexPath) as? FeedCell else {
			return UICollectionViewCell()
		}
		let viewObject = viewModel.viewObject(for: indexPath.row)
		cell.configure(viewObject: viewObject)
		return cell
	}
}

extension FeedViewController: SlideSheetPresented {
	var presentedView: UIView {
		view
	}
	
	var scrollView: UIScrollView? {
		collectionView
	}
}
