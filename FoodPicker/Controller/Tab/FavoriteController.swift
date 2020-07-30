//
//  FavoriteController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let favoriteIdentifier = "FavoriteCell"
private let searchBarIdentifier = "SearchBar"

class FavoriteController: UICollectionViewController {
    
    //MARK: - Properties
    var likedRestaurants = [Restaurant]() {
        didSet{
            collectionView.reloadData()
            print("DEBUG: Did set in favorite Controller")
        }
    }
    
    private let navBarView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 36
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "My Favorite"
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.centerY(inView: view, yConstant: 24)
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .backgroundColor
        configureCollectionView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }

    //MARK: - Helpers
    func configureNavBar(){
        navigationController?.navigationBar.isHidden = true
        view.addSubview(navBarView)
        navBarView.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          height: 104)
    }
    
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: favoriteIdentifier)
        collectionView.register(SearchBar.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: searchBarIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 104 + 16 - 44, left: 0, bottom: 0, right: 0)
    }
    
}

extension FavoriteController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedRestaurants.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteIdentifier, for: indexPath)
        as! FavoriteCell
        cell.restaurant = self.likedRestaurants[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: searchBarIdentifier, for: indexPath) as! SearchBar
        
        return header
    }

}

extension FavoriteController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-32 , height: 88)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 96)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
