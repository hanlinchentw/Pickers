//
//  AllRestaurantsSection.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/1.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
private let restaurantsListIdentifier = "ListCell"

protocol AllRestaurantsSectionDelegate: AnyObject {
//  func didSelectRestaurant(restaurant:Restaurant)
//  func didTapRestaurant(restaurant:Restaurant)
//  func shouldSeeAllRestaurants(restaurants:[Restaurant])
}
class AllRestaurantsSectionView: UICollectionReusableView {
  //MARK: - Properties
  var restaurants = [RestaurantViewObject]() { didSet { self.tableView.reloadData() } }
  weak var delegate : AllRestaurantsSectionDelegate?

  private let titleLabel : UILabel = {
    let label = UILabel()
    label.text = "All Restaurants"
    label.textColor = .black
    label.font = UIFont(name: "Avenir-Heavy", size: 24)
    return label
  }()

  private let tableView = UITableView()
  //MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame:frame)
    configureUI()
    configureTableview()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Seletors
  @objc func SeeMoreRestaurants(){

  }
}
// MARK: - UITableViewDelegate
extension AllRestaurantsSectionView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.restaurants.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: restaurantsListIdentifier, for: indexPath) as! RestaurantListCell

    let presenter = RestaurantCardPresenter(restaurant: self.restaurants[indexPath.row])

    cell.selectionStyle = .none
    cell.presenter = presenter
    cell.config = .all
    return cell
  }

  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let likeAction = UIContextualAction(style: .normal, title: "Like") { [weak self] (action, view, completionHandler) in
      guard let _ = self else { return }
      print("Liked")
      completionHandler(true)
    }
    likeAction.backgroundColor = .butterscotch
    likeAction.image = UIImage(named: "icnHeartSmallW")?.withRenderingMode(.alwaysOriginal)
    let configuration = UISwipeActionsConfiguration(actions: [likeAction])
    configuration.performsFirstActionWithFullSwipe = true

    return configuration
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    delegate?.didTapRestaurant(restaurant: restaurants[indexPath.row])
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = .white
    let label = UILabel()
    label.layer.cornerRadius = 12
    label.layer.borderColor = UIColor.black.cgColor
    label.layer.borderWidth = 1
    label.textAlignment = .center
    label.text = "See All Restaurants"
    label.font = UIFont.arialBoldMT
    label.textColor = .black
    view.addSubview(label)
    label.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                 paddingTop: 16, paddingLeft: 40, paddingRight: 40,
                 width: 335, height: 48)

    let tap = UITapGestureRecognizer(target: self, action: #selector(SeeMoreRestaurants))
    label.addGestureRecognizer(tap)
    return view
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 72
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 117
  }
}

// MARK: - UI
extension AllRestaurantsSectionView {
  func configureUI(){
    addSubview(titleLabel)
    titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 32, paddingLeft: 24, height: 36)
  }
  func configureTableview(){
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(RestaurantListCell.self, forCellReuseIdentifier: restaurantsListIdentifier)

    tableView.layer.cornerRadius = 16
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none

    addSubview(tableView)
    tableView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor)
  }
}
