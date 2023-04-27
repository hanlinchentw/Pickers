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
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setupCollectionView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension FeedViewController: StatefulViewController {
	func hasContent() -> Bool {
		return false
	}
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hello", for: indexPath) as! UICollectionViewCell
		cell.backgroundColor = indexPath.section == 0 ? .red : .blue
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
		headerView.backgroundColor = .systemBackground
		let label = UILabel()
		label.text = indexPath.section == 0 ? "Popular" : "Nearyby"
		label.font = UIFont.boldSystemFont(ofSize: 20)
		headerView.addSubview(label)
		label.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		return headerView
	}
}
