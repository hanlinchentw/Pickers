//
//  SearchTableViewController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/22.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

class SearchResultController: UIViewController {
    //MARK: - Properties
    var searchTerm = String()
    var searchResult = [Restaurant]() { didSet{ self.filterResult = self.searchResult }}
    var filterResult = [Restaurant]() {
        didSet {
            self.resultView.restaurants = self.filterResult
            self.resultView.reloadData()
        }
    }
    private let statLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 14)
        label.textColor = .black
        return label
    }()
    private let failLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private var filterView = FilterView()
    private let resultView = RestaurantsList()
    private lazy var failView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.font = UIFont(name: "Arial-BoldMT", size: 24)
        label.textAlignment = .center
        label.text = "Sorry..."
        label.textColor = .black
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(failLabel)
        failLabel.anchor(top: label.bottomAnchor, left: view.leftAnchor,
                         right: view.rightAnchor, paddingTop: 12)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "illustrationSearchXresult")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        imageView.anchor(top: failLabel.bottomAnchor,left: view.leftAnchor,
                         right: view.rightAnchor, bottom: view.bottomAnchor)
        return view
    }()
    private var actionSheetLauncher : ActionSheetLauncher?
    
    private var sortOption: SortOption = .nearby { didSet{ self.filterView.configureSortOptionText(text: sortOption.description)}}
    private var priceRanges: [PriceRange] = [.oneSign, .twoSign, .threeSign, .fourSign]
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .backgroundColor
        configureFailedView()
        configureFilterView()
        configureUI()
        checkIfRestaurantIsSelected()
    }
    override func didMove(toParent parent: UIViewController?) {
        print("DEBUG: Did move")
    }
    //MARK: - Helpers
    func checkIfSearchSuccess(){
        let isFail = searchResult.isEmpty
        failView.isHidden = !isFail
        statLabel.isHidden = isFail
        resultView.isHidden = isFail
        filterView.isHidden = isFail
        configureLabelText(isFail: isFail)
    }
    
    func sortRestaurantBy(option:SortOption){
        switch option {
        case .nearby:
            searchResult.sort{ $0.distance < $1.distance }
        case .popular:
            searchResult.sort { $0.reviewCount > $1.reviewCount}
        case .rating:
            searchResult.sort { $0.rating > $1.rating}
        }
        
    }
    //MARK: - Restaurant Check(Selected or not) process
    func checkIfRestaurantIsSelected(){
        let coreConnect = CoredataConnect(context: context)
        for (index, item) in filterResult.enumerated() {
            coreConnect
                .checkIfRestaurantIsIn(entity: selectedEntityName,id: item.restaurantID) { isSelected in
                    self.filterResult[index].isSelected = isSelected
                    self.resultView.reloadData()
            }
        }
    }
}
//MARK: - RestaurantsListDelegate
extension SearchResultController : RestaurantsListDelegate {
    func didSelectRestaurant(_ restaurant: Restaurant) {
        print("DEBUG: Selected restaurant from search view controller ... ")
        guard let motherVC = parent as? SearchController else { return }
        motherVC.didSelectRestaurant(restaurant: restaurant)
    }
}
//MARK: - FilterViewDelegate
extension SearchResultController : FilterViewDelegate {
    func didTapSortButton() {
        actionSheetLauncher = ActionSheetLauncher(mode: .sort)
        actionSheetLauncher?.selectedSortOption = self.sortOption
        actionSheetLauncher?.delegate = self
        actionSheetLauncher?.animateIn(sortOption: self.sortOption)
    }
    func didTapPriceButton() {
        actionSheetLauncher = ActionSheetLauncher(mode: .price)
        
        actionSheetLauncher?.selectedIndexPath = Set(self.priceRanges.map{ $0.rawValue }.map{IndexPath(row: $0, section: 0)})
        actionSheetLauncher?.delegate = self
        actionSheetLauncher?.animateIn(priceRange: self.priceRanges)
    }
}
//MARK: - ActionSheetLauncherDelegate
extension SearchResultController: ActionSheetLauncherDelegate {
    func didTapFilterCell(sortOption: SortOption) {
        self.sortOption = sortOption
        self.sortRestaurantBy(option: sortOption)
    }
    func didTapApplyButton(priceRange: [PriceRange]) {
        self.priceRanges = priceRange
        filterWithPriceRange(ranges: priceRange)
    }
    func filterWithPriceRange(ranges: [PriceRange]){
        let rangeString = ranges.map{$0.description}
        self.filterResult = self.searchResult.filter{ rangeString.contains($0.price) }
    }
}

//MARK: - Auto layout and configure method
extension SearchResultController {
    func configureUI(){
        view.addSubview(statLabel)
        statLabel.anchor(top: filterView.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        resultView.listDelegate = self
        view.addSubview(resultView)
        self.resultView.anchor(top: statLabel.bottomAnchor, left: view.leftAnchor,
                               right: view.rightAnchor,bottom: view.bottomAnchor,
                               paddingTop: 8)
        let tabHeight = self.tabBarController?.tabBar.frame.height ?? 0
        self.resultView.contentInset.bottom = tabHeight
    }
    func configureFilterView(){
        resultView.config = .sheet
        resultView.isScrollEnabled = true
        filterView.delegate = self
        filterView.backgroundColor = .backgroundColor
        view.addSubview(filterView)
        filterView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 40)
    }
    func configureFailedView(){
        view.addSubview(failView)
        failView.centerX(inView: self.view)
        let topPadding = 120 * view.heightMultiplier
        let imageSize = 460 * view.heightMultiplier
        failView.anchor(top: view.topAnchor, paddingTop: topPadding, width: imageSize, height: imageSize)
        
    }
    func configureLabelText(isFail:Bool){
        if isFail{
            failLabel.text = """
                    We didn't find a match of
                    "\(searchTerm)"
                    Try search for somthing else instead.
                    """
        }else{
            statLabel.text = "\(searchResult.count) results for ' \(searchTerm) ' "
        }
    }
}

