//
//  PlaceListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

protocol PlaceListViewDelegate: AnyObject {
	func placesCount() -> Int
	func viewModel(atIndex index: Int) -> PlaceViewModel
	func didTapAddButton(viewModel: PlaceViewModel)
}

final class PlaceListView: UIView {
	var collectionView: UICollectionView!
	weak var delegate: PlaceListViewDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCollectionView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update() {
		collectionView.reloadData()
	}
}

extension PlaceListView: UICollectionViewDelegate {}

extension PlaceListView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		delegate?.placesCount() ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PlaceListViewCell.self), for: indexPath) as? PlaceListViewCell else {
			return UICollectionViewCell()
		}
		cell.viewModel = delegate?.viewModel(atIndex: indexPath.row)
		cell.configure()
		cell.delegate = self
		return cell
	}
}

extension PlaceListView: PlaceListViewCellDelegate {
	func didTapAddButton(viewModel: PlaceViewModel) {
		delegate?.didTapAddButton(viewModel: viewModel)
	}
}

extension PlaceListView {
	func setupCollectionView() {
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: ViewLayout())
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.showsVerticalScrollIndicator = false
		collectionView.register(PlaceListViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(PlaceListViewCell.self))
		addSubview(collectionView)
		collectionView.fit(inView: self)
	}

	class ViewLayout: UICollectionViewCompositionalLayout {

		init() {
			super.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
				let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				item.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
				let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, repeatingSubitem: item, count: 1)
				let section = NSCollectionLayoutSection(group: group)
				section.interGroupSpacing = 32
				section.contentInsets = .init(top: 0, leading: 0, bottom: 120, trailing: 0)
				return section
			}
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
