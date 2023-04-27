//
//  ListViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import StatefulViewController
import SnapKit

final class FeedViewController: UIViewController {
	var collectionView: UICollectionView!
	lazy var dataSource = makeDataSource()

	init() {
		super.init(nibName: nil, bundle: nil)
		setupCollectionView()
		
		collectionView.delegate = self
		collectionView.dataSource = dataSource
		applyDataSource()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}

extension FeedViewController: StatefulViewController {
	func hasContent() -> Bool {
		return false
	}
}

extension FeedViewController: UICollectionViewDelegate {
}
