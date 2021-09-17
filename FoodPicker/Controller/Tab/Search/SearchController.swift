//
//  SearchController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreLocation
import Combine

private let searchHeaderIdentifier = "searchBar"
private let searchShortcutIdentifier = "searchShortcut"
private let searchFooterIdentifier = "categoryWall"

class SearchController: UICollectionViewController, MBProgressHUDProtocol {
    //MARK: - Properties
    var restaurants = [Restaurant]() { didSet{ self.resultVC.searchResult = self.restaurants }}
    private let tableView = UITableView()
    private var errorView : ErrorView?
    private var historicalRecords = [String]() {
        didSet{
            DispatchQueue.main.async {
                print(self.historicalRecords)
                self.collectionView.reloadData()
            }
        }
    }
    private let searchVC = SearchTableViewController(style: .grouped)
    private let resultVC = SearchResultController()
    private let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    private var subscriber = Set<AnyCancellable>()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchHistoricalRecord()
        collectionView.backgroundColor = .backgroundColor
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
    }
    //MARK: - Helpers
    func configureCollectionView(){
        collectionView.register(SearchShortcutSection.self, forCellWithReuseIdentifier: searchShortcutIdentifier)
        collectionView.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: searchHeaderIdentifier)
        collectionView.register(CategoryCardWall.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: searchFooterIdentifier)
    }
    func isDataLoadedSuccessfully(_ isSuccess: Bool){
        self.hideLoadingAnimation()
        if isSuccess {
            if errorView != nil {
                self.errorView?.removeFromSuperview()
                self.errorView = nil
            }
            self.collectionView.isHidden = false
        }else{
            self.errorView?.removeFromSuperview()
            errorView = ErrorView()
            if errorView != nil {
                self.view.addSubview(errorView!)
                self.observeErrorView()
            }
            self.collectionView.isHidden = true
        }
    }
    fileprivate func observeErrorView() {
        if errorView != nil {
            errorView?.reloadButton
                .publisher(for: .touchUpInside)
                .sink { [weak self]_ in
                    self?.fetchHistoricalRecord()
                }.store(in: &subscriber)
        }
    }
    //MARK: - API
    func addHistoricalRecordByTerm(term:String){
        let connect = CoredataConnect(context: self.context)
        connect.saveSearchHistoryInEntity(term: term)
    }
    
    func fetchHistoricalRecord(){
        let connect = CoredataConnect(context: self.context)
        connect.fetchSearchHistory { terms in
            self.historicalRecords = terms
        }
    }
    func fetchRestautantsByterms(term: String){
        self.showLoadingAnimation()
        guard let location = LocationHandler.shared.locationManager.location?.coordinate else { return }
        NetworkService.shared.fetchRestaurantsByTerm(lat: location.latitude, lon: location.longitude, terms: term) { (restaurants, error) in
            if error == .noInternet {
                self.isDataLoadedSuccessfully(false)
                return
            }
            if let restaurants = restaurants{
                self.resultVC.searchTerm = term
                self.restaurants = restaurants
                if !restaurants.isEmpty{
                    self.addHistoricalRecordByTerm(term: term)
                    for (index, item) in self.restaurants.enumerated() {
                        self.checkIfRestaurantIsSelected(context: self.context, restaurant: item) { isSelected in
                            self.restaurants[index].isSelected = isSelected
                        }
                    }
                    self.isDataLoadedSuccessfully(true)
                    self.resultVC.searchResult = self.restaurants
                }else{
                    self.hideLoadingAnimation()
                }
            }}}
    func searchRestaurants(withKeyword keyword: String) {
        self.fetchRestautantsByterms(term: keyword)
        self.addChild(self.resultVC)
        self.view.addSubview(self.resultVC.view)
        self.resultVC.view.alpha = 0
        self.resultVC.view.frame = self.view.frame
        self.resultVC.view.frame.origin.y =
            (self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0))?.frame.origin.y)! + 20 + 16
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.shouldCloseKeyboard(should: false, term: keyword)
            self.showResultView(shouldShow: true)
            self.showSearchTable(shouldShow: false)
            self.resultVC.checkIfSearchSuccess()
            self.hideLoadingAnimation()
        }
    }
    
    func didSelectRestaurant(restaurant: Restaurant) {
        guard let tab = self.tabBarController as? HomeController else { return }
        do {
            try tab.updateSelectedRestaurants(from: self, restaurant: restaurant)
            updateSelectedRestaurantsInCoredata(context: context, restaurant: restaurant)
            updateSelectStatus(restaurantID: restaurant.restaurantID)
        }catch  SelectRestaurantResult.upToLimit{
            self.presentPopupViewWithoutButton(title: "Sorry..", subtitle: "You can only select 8 restaurant. 😢")
            self.resultVC.searchResult = self.restaurants
        }catch{
            print("DEBUG: Failed to select restaurant.")
        }
    }
    
    func updateSelectStatus(restaurantID: String){
        if let index = self.restaurants.firstIndex(where: { $0.restaurantID == restaurantID}) {
            self.restaurants[index].isSelected.toggle()
        }
    }
}
//MARK: - UICollectionviewDelegate / Datasoruce
extension SearchController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchShortcutIdentifier, for: indexPath)
            as! SearchShortcutSection
        cell.titleLabel.text = "Recent Searches"
        cell.keywords = historicalRecords
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: searchHeaderIdentifier, for: indexPath) as! SearchHeader
            header.delegate = self
            return header
        }else{
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: searchFooterIdentifier, for: indexPath) as! CategoryCardWall
            footer.delegate = self
            return footer
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height : CGFloat = historicalRecords.isEmpty ? 0 : 56
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40 + 24*2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
//MARK: -
extension SearchController: CategoryCardWallDelegate {
    func searchRestaurantByTappingCard(_ keyword: String) {
        self.showLoadingAnimation()
        self.searchRestaurants(withKeyword: keyword)
    }
}

//MARK: - Page switch
extension SearchController{
    func showSearchTable(shouldShow: Bool){
        if shouldShow{
            self.searchVC.closeTheKeyBoardAndCleanTextField()
            self.searchVC.view.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.searchVC.view.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchVC.view.alpha = 0
            }) { (_) in
                self.searchVC.view.isHidden = true
                self.searchVC.removeFromParent()
            }
        }
    }
    func showResultView(shouldShow: Bool){
        if shouldShow{
            self.resultVC.view.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.resultVC.view.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.resultVC.view.alpha = 0
            }) { (_) in
                self.resultVC.view.isHidden = true
            }
        }
    }
    func shouldCloseKeyboard(should: Bool, term: String? = nil){
        guard let header = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)[0] as? SearchHeader else { return }
        if should{
            header.searchBar.text?.removeAll()
            header.searchBar.clearButtonMode = .whileEditing
        }else{
            header.searchBar.text = term
            header.searchBar.clearButtonMode = .always
        }
    }
}
//MARK: - SearchHeaderDelegate
extension SearchController: SearchHeaderDelegate{
    func didTapSearchHeader() {
        self.fetchHistoricalRecord()
        searchVC.historicalRecords = self.historicalRecords
        addChild(searchVC)
        searchVC.delegate = self
        view.addSubview(searchVC.view)
        searchVC.view.alpha = 0
        searchVC.view.frame = self.view.frame
        self.showSearchTable(shouldShow: true)
    }
    func didClearSearchHeader() {
        self.fetchHistoricalRecord()
        self.showResultView(shouldShow: false)
        self.showSearchTable(shouldShow: false)
        shouldCloseKeyboard(should: true, term: nil)
    }
}

//MARK: - SearchTableViewControllerDelegate
extension SearchController: SearchTableViewControllerDelegate{
    func didTapBackButton() {
        self.showSearchTable(shouldShow: false)
        shouldCloseKeyboard(should: true, term: nil)
    }
    func didSearchbyTerm(term: String) {
        self.showLoadingAnimation()
        self.searchRestaurants(withKeyword: term)
    }
}
