//
//  FoodCardCell.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let cardIdentifier = "CardCell"
private let footerIdentifier = "footerView"

//protocol FilterResultSectionDelegate: RestaurantAPI {
//  func shouldShowMoreRestaurants(_ restaurants: [Restaurant])
//}

class MainListSectionView: UICollectionViewCell {
  //MARK: - Properties
//  weak var delegate : FilterResultSectionDelegate?
  var sectionViewObject: MainListSectionViewObject? { didSet {
    guard let viewObject = sectionViewObject else { return }
    self.titleLabel.text = viewObject.section.description
    collectionView.reloadData()
  }}

  private lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Arial-BoldMT", size: 24)
    label.textColor = .black
    return label
  }()

  private lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .backgroundColor
    return cv
  }()
  //MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    configureCollectionView()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainListSectionView : UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 6
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardIdentifier, for: indexPath)
    guard let cell = cell as? RestaurantCardCell,
          let viewObject = sectionViewObject else { return cell }

    if !viewObject.content.isEmpty{ cell.presenter = RestaurantCardPresenter(restaurant: viewObject.content[indexPath.row]) }
//    cell.delegate = self
    return cell

  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        delegate?.pushToDetailVC(restaurants[indexPath.row])
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! MoreRestaurantsFooterView
    footer.delegate = self
    return footer
  }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MainListSectionView : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.restaurantCardCGSize
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    let width = 300
    let height = 280
    return CGSize(width: width, height: height)
  }
}
//MARK: - RestaurantAPI
//extension MainListSectionView : RestaurantAPI {
//  func didLikeRestaurant(restaurant: Restaurant) {
//    delegate?.didLikeRestaurant(restaurant: restaurant)
//  }
//  func didSelectRestaurant(restaurant: Restaurant) {
//    delegate?.didSelectRestaurant(restaurant: restaurant)
//  }
//}
//MARK: - MoreRestaurantsFooterViewDelegate
extension MainListSectionView: MoreRestaurantsFooterViewDelegate{
  func shouldShowMoreRestaurants() {
    //        delegate?.shouldShowMoreRestaurants(self.restaurants)
  }
}
//MARK: - Autolayout
extension MainListSectionView {
  func configureUI(){
    addSubview(titleLabel)
    titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16,
                      paddingLeft: 24, height: 36/(self.iPhoneSEMutiplier))
    addSubview(collectionView)
    collectionView.anchor(top: titleLabel.bottomAnchor, left:leftAnchor,right: rightAnchor, bottom: bottomAnchor,
                          paddingTop: 4, paddingLeft: 16)
  }
}
//MARK: - Collectionview setup
extension MainListSectionView {
  func configureCollectionView(){
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.showsHorizontalScrollIndicator  =  false
    collectionView.register(RestaurantCardCell.self, forCellWithReuseIdentifier: cardIdentifier)
    collectionView.register(MoreRestaurantsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
  }
}
