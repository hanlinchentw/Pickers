////
////  ListInfoCell.swift
////  FoodPicker
////
////  Created by 陳翰霖 on 2020/11/18.
////  Copyright © 2020 陳翰霖. All rights reserved.
////
//
//import UIKit
//protocol ListInfoCellDelagete: AnyObject {
//    func shouldExpandList(_ cell: ListInfoCell, _ shouldExpand: Bool, list: List)
//    func didTapMoreButton(list: List)
//}
//class ListInfoCell: UITableViewCell{
//    //MARK: - Properties
//    var list: List? { didSet { configure() }}
//    weak var delegate: ListInfoCellDelagete?
//    var isExpand = false
//
//    let restaurantTableView = RestaurantsList()
//    private let containerView = UIView()
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name:"Arial-BoldMT", size: 18)
//        label.textColor = .black
//        return label
//    }()
//    private let timestampLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name:"ArialMT", size: 14)
//        label.textColor = .gray
//        return label
//    }()
//
//    private let restaurantsNumLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name:"ArialMT", size: 14)
//        label.textColor = .black
//        return label
//    }()
//    private lazy var moreButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "icnMoreThreeDot")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.setDimension(width: 40, height: 40)
//        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
//        button.isUserInteractionEnabled = true
//        return button
//    }()
//    private lazy var expandButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "icnArrowDown")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.setDimension(width: 40, height: 40)
//        button.addTarget(self, action: #selector(didTapExpandButton), for: .touchUpInside)
//        button.isUserInteractionEnabled = true
//        return button
//    }()
//    //MARK: - Lifecycle
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureCell()
//    }
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//    //MARK: - Selectors
//    @objc func didTapExpandButton(){
//        guard let list = list else { return }
//
//        print("DEBUG: Should expand list info ... ")
//        self.isExpand.toggle()
//        delegate?.shouldExpandList(self, self.isExpand, list: list)
//        self.restaurantTableView.beginUpdates()
//        self.restaurantTableView.endUpdates()
//        let imageName = isExpand ? "icnArrowUp" : "icnArrowDown"
//        expandButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
//    }
//
//    @objc func didTapMoreButton(){
//        guard let list = self.list else { return  }
//        delegate?.didTapMoreButton(list: list)
//    }
//}
////MARK: - List animation
//extension ListInfoCell {
//    func animateIn(height: CGFloat){
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
//            self.restaurantTableView.transform = CGAffineTransform(translationX: 0, y: -height)
//        } completion: { _ in
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
//                self.restaurantTableView.transform = .identity
//            }
//        }
//    }
//}
////MARK: - Auto layout and view set up Method
//extension ListInfoCell {
//    func configure(){
//        guard let list = list else { return }
//        nameLabel.text = list.name
//        restaurantsNumLabel.text = "\(list.restaurantsID.count) restaurants"
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let day = formatter.string(from: list.date)
//        timestampLabel.text = day
//    }
//    func configureCell(){
//        backgroundColor = .backgroundColor
//        containerView.backgroundColor = .white
//
//        addSubview(containerView)
//        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, width: self.frame.width, height:  116)
//
//        let stack = UIStackView(arrangedSubviews: [nameLabel, timestampLabel, restaurantsNumLabel])
//        stack.axis = .vertical
//        stack.distribution = .fillProportionally
//        contentView.addSubview(stack)
//        stack.anchor(top:containerView.topAnchor, left: containerView.leftAnchor,
//                     bottom: containerView.bottomAnchor,
//                     paddingTop: 8, paddingLeft: 16, paddingBottom: 8)
//
//        let buttonStack = UIStackView(arrangedSubviews: [moreButton, expandButton])
//        buttonStack.axis = .vertical
//        contentView.addSubview(buttonStack)
//        buttonStack.anchor(top: containerView.topAnchor, right: containerView.rightAnchor,
//                           bottom: containerView.bottomAnchor,
//                           paddingTop: 4, paddingRight: 16, paddingBottom: 4)
//    }
//    func configureTableView(){
//        guard let list = list else { return }
//        restaurantTableView.restaurants = list.restaurants
//        restaurantTableView.config = .list
//        restaurantTableView.separatorStyle = .singleLine
//        self.insertSubview(restaurantTableView, belowSubview: containerView)
//        restaurantTableView.anchor(top: containerView.bottomAnchor, left: leftAnchor,
//                                   right: rightAnchor, bottom: bottomAnchor)
//    }
//}
