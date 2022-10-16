//
//  SearchViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/8.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import Combine



class SearchViewController: UIViewController, Selectable {
	typealias DataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>
	// MARK: - Property
	@Inject var selectService: SelectedCoreService
	weak var coordinator: SearchCoordinator?
	
	private var vm = SearchListViewModel()
	
	private let searchTextField = SearchTextField()
	
	private lazy var backButton: UIButton = {
		var configuration = UIButton.Configuration.plain()
		configuration.image = UIImage(named: "icnArrowBack")
		let btn = UIButton(configuration: configuration, primaryAction: UIAction() { _ in
			self.coordinator?.didFinishSearching()
		})
		btn.setDimension(width: 24, height: 44)
		btn.isHidden = true
		return btn
	}()
	
	private let dummyView = UIView()
	
	private lazy var menuButton: MenuButton = {
		let btn = MenuButton()
		btn.isHidden = true
		let menuChildren = SectionItem.fixedCategories.map { text in
			UIAction(title: text) { action in
				self.vm.searchFor(text: text)
				self.searchTextField.text = text
			}}
		btn.setMenuChildren(menuChildren)
		return btn
	}()
	
	
	private let noResultView = ResultNotFoundView()
	
	private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
	
	private lazy var dataSource: DataSource = createDataSource()
	
	private var set = Set<AnyCancellable>()
	
	var isRecommendSectionShown: Bool {
		let currentSections = self.dataSource.snapshot().sectionIdentifiers
		return currentSections.contains(where: { $0.rawValue == Section.Recommend.rawValue })
	}
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.isHidden = true
		view.backgroundColor = .backgroundColor
		setupSearchTextfieldAndBackButton()
		setupNoResultView()
		setupMenuView()
		setupCollectionView()
		bindTextfield()
		bindSearchState()
		bindRefresh()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		searchTextField.becomeFirstResponder()
		viewAppearAnimation()
	}
	
	func viewAppearAnimation() {
		UIView.animate(withDuration: 0.5, delay: 1.5, animations: {
			self.view.isHidden = false
		}, completion: { _ in
			UIView.animate(withDuration: 0.3, delay: 0.1) {
				self.backButton.isHidden = false
				self.dummyView.isHidden = true
			}
		})
	}
}
// MARK: - Binding
extension SearchViewController {
	func bindTextfield() {
		searchTextField.textPublisher
			.filter({ text in
				let textIsBeenCleared = text == nil || text!.isEmpty
				return textIsBeenCleared
			})
			.sink { _ in
				self.vm.clearResult()
			}
			.store(in: &set)
	}
	
	func bindSearchState() {
		vm.$searchState
			.sink { [weak self] state in
				OperationQueue.main.addOperation {
					guard let self = self else { return }
					switch state {
					case .idle:
						self.showRecommendSection()
					case .searching:
						MBProgressHUDHelper.showLoadingAnimation()
					case .done(let result):
						if self.isRecommendSectionShown {
							self.hideRecommendSectionWithAnimation() {
								self.showSearchResultWithAnimation(result: result)
							}
						} else {
							self.showSearchResultWithAnimation(result: result)
						}
					case .error(_):
						self.showErrorView()
					}
				}
			}
			.store(in: &set)
	}
	
	func bindRefresh() {
		vm.$isRefresh
			.sink { [weak self] isRefresh in
				guard let self = self else {
					return
				}
				let snapshot = self.createSearchResultSnapshot(result: self.vm.viewObjects)
				self.dataSource.apply(snapshot, animatingDifferences: true)
			}
			.store(in: &set)
	}
	
	func showRecommendSection() {
		self.menuButton.isHidden = true
		self.collectionView.backgroundColor = .backgroundColor
		self.dataSource.apply(self.createRecommendModeSnapshot())
	}
	
	func hideRecommendSectionWithAnimation(completion: (() -> Void)? = nil) {
		UIView.animate(withDuration: 0.5, animations: {
			let scale = CGAffineTransform(scaleX: 0.05, y: 0.05)
			let translation = CGAffineTransformMakeTranslation(16 - self.collectionView.frame.width/2, 16 - self.collectionView.frame.height/2)
			self.collectionView.transform = CGAffineTransformConcat(scale, translation)
			self.collectionView.alpha = 0
			self.menuButton.isHidden = false
		}, completion: { _ in completion?() })
	}
	
	func showSearchResultWithAnimation(result: Array<RestaurantViewObject>) {
		self.collectionView.backgroundColor = .white
		self.collectionView.transform = .identity
		self.dataSource.apply(self.createSearchResultSnapshot(result: result))
		UIView.animate(withDuration: 0.5) {
			self.collectionView.alpha = 1
		}
		MBProgressHUDHelper.hideLoadingAnimation()
	}
	
	func showErrorView() {
		MBProgressHUDHelper.hideLoadingAnimation()
		self.collectionView.alpha = 0
		self.noResultView.isHidden = false
	}
}
// MARK: -  CollectionView setup
extension SearchViewController {
	func configureCategoryRegistration() -> UICollectionView.CellRegistration<CategoryCardCell, String> {
		let categoryCellRegistration = UICollectionView.CellRegistration<CategoryCardCell, String> { cell, _, imageName in
			cell.imageName = imageName
		}
		return categoryCellRegistration
	}
	
	func configureResultCellRegistration() -> UICollectionView.CellRegistration<RestaurantListCell, RestaurantViewObject> {
		let searchResultRegistration = UICollectionView.CellRegistration<RestaurantListCell, RestaurantViewObject> { cell, _, restaurant in
			let restaurant = restaurant
			let actionButtonMode: ActionButtonMode = restaurant.isSelected ? .select : .deselect
			cell.presenter = RestaurantPresenter(restaurant: restaurant, actionButtonMode: actionButtonMode)
			cell.delegate = self
		}
		return searchResultRegistration
	}
	
	func createDataSource() -> DataSource {
		let recommendCellRegistration = self.configureCategoryRegistration()
		let searchResultCellResgistration = self.configureResultCellRegistration()
		let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, sectionItem in
			switch sectionItem {
			case .Recommend(let imageName):
				return collectionView.dequeueConfiguredReusableCell(using: recommendCellRegistration, for: indexPath, item: imageName)
			case .Search(let restaurant):
				return collectionView.dequeueConfiguredReusableCell(using: searchResultCellResgistration, for: indexPath, item: restaurant)
			}
		}
		return dataSource
	}
	
	func createRecommendModeSnapshot() -> Snapshot {
		var snapshot = Snapshot()
		snapshot.appendSections([Section.Recommend])
		snapshot.appendItems(SectionItem.fixedRecommendSectionItems, toSection: Section.Recommend)
		return snapshot
	}
	
	func createSearchResultSnapshot(result: Array<RestaurantViewObject>) -> Snapshot {
		var snapshot = Snapshot()
		snapshot.appendSections([Section.Search])
		let items = self.vm.viewObjects.map { SectionItem.Search(restaurant: $0) }
		snapshot.appendItems(items, toSection: Section.Search)
		return snapshot
	}
}
// MARK: - RestaurantListCellDelegate
extension SearchViewController: RestaurantListCellDelegate {
	func didTapActionButton(_ restaurant: RestaurantViewObject) {
		selectRestaurant(isSelected: restaurant.isSelected, restaurant: restaurant)
	}
}
// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let text = textField.text { self.vm.searchFor(text: text) }
		return true
	}
}
// MARK: - UI setup
extension SearchViewController {
	func setupSearchTextfieldAndBackButton() {
		searchTextField.delegate = self
		let stack = UIStackView(arrangedSubviews: [backButton, searchTextField, dummyView])
		stack.axis = .horizontal
		stack.alignment = .leading
		stack.distribution = .fillProportionally
		stack.spacing =  8
		
		dummyView.setDimension(width: 52)
		
		view.addSubview(stack)
		stack.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: SafeAreaUtils.top + 16, paddingLeft: 16, paddingRight: 16)
	}
	
	func setupCollectionView() {
		collectionView.dataSource = dataSource
		collectionView.delegate = self
		collectionView.backgroundColor = .backgroundColor
		collectionView.layer.cornerRadius = 24
		collectionView.showsVerticalScrollIndicator = false
		view.addSubview(collectionView)
		collectionView.anchor(
			top: menuButton.bottomAnchor,
			left: view.leftAnchor,
			right: view.rightAnchor,
			bottom: view.bottomAnchor,
			paddingTop: 16
		)
	}
	
	func setupMenuView() {
		view.addSubview(menuButton)
		menuButton.anchor(
			top: searchTextField.bottomAnchor,
			left: view.leftAnchor,
			paddingTop: 16,
			paddingLeft: 16
		)
		menuButton.setDimension(height: 36)
	}
	
	func setupNoResultView() {
		noResultView.isHidden = true
		view.addSubview(noResultView)
		noResultView.center(inView: view)
		noResultView.setDimension(width: UIScreen.screenWidth - 32)
	}
}
// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			let item = dataSource.snapshot().itemIdentifiers[indexPath.row]
			self.vm.searchFor(text: item.identifier)
			self.searchTextField.text = item.identifier
		}
	}
}
// MARK: - make layout of Catergory card wall
extension SearchViewController {
	func makeGridLayoutSection() -> NSCollectionLayoutSection {
		let bigItem = NSCollectionLayoutItem.create(widthFraction: 2/3, heightFraction: 1)
		bigItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
		
		let verticalGroup = NSCollectionLayoutGroup.createSpacingEvenlyVerticalGroup(count: 2, spacing: 8, widthFraction: 1/3, heightFraction: 1)
		
		let bigGroup = NSCollectionLayoutGroup.createHorizontalGroup(subitems: [bigItem, verticalGroup], widthFraction: 1, heightFraction: 1/4)
		
		let tripletGroup = NSCollectionLayoutGroup.createSpacingEvenlyHorizontalGroup(count: 3, spacing: 8, widthFraction: 1, heightFraction: 1/7)
		
		let group = NSCollectionLayoutGroup.createVerticalGroup(subitems: [bigGroup, tripletGroup, tripletGroup, tripletGroup], widthFraction: 1, heightFraction: 1)
		group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
		
		return NSCollectionLayoutSection(group: group)
	}
	
	func makeCollectionViewLayout() -> UICollectionViewLayout {
		UICollectionViewCompositionalLayout {
			[weak self] sectionIndex, environment in
			guard let text = self?.searchTextField.text, !text.isEmpty else {
				return self?.makeGridLayoutSection()
			}
			let item = NSCollectionLayoutItem.create(widthFraction: 1, heightFraction: 1)
			let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item])
			return NSCollectionLayoutSection(group: group)
		}
	}
}
