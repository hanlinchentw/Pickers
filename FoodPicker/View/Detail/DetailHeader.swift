//
//  DetailHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/31.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let photoCellIdentifier = "PhotoCell"

import ImageSlideshow

protocol DetailHeaderDelegate : class {
    func handleDismissDetailPage()
    func handleLikeRestaurant()
    func handleShareRestaurant()
}

class DetailHeader : UICollectionReusableView {
    //MARK: - Properties
    weak var delegate : DetailHeaderDelegate?
    var viewModel: DetailHeaderViewModel? { didSet{ configureUI()}}
    private let slideShow = ImageSlideshow()
    private lazy var backbuttonContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icnBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissDetailPage), for: .touchUpInside)
        
        view.addSubview(button)
        button.anchor(right:view.rightAnchor, paddingRight: 8,
                        width: 32, height: 32)
        button.centerY(inView: view)
        
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    private lazy var shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(UIImage(named: "icnShare")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShareButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.anchor(width : 40, height: 40)
        
        return button
    }()
    private lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(UIImage(named: "icnHeart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.anchor(width : 40, height: 40)
        
        return button
    }()
    private lazy var photoCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
       
        return cv
    }()
    
    private let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .customblack
        pc.pageIndicatorTintColor = .white
        return pc
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(slideShow)
        slideShow.fit(inView: self)
        addSubview(backbuttonContainerView)
        backbuttonContainerView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
                                       paddingTop: 56,
                                       width: 58, height: 40)
        addSubview(shareButton)
        shareButton.centerY(inView: backbuttonContainerView)
        shareButton.anchor(right:rightAnchor, paddingRight: 8)
        
        addSubview(likeButton)
        likeButton.centerY(inView: backbuttonContainerView)
        likeButton.anchor(right:shareButton.leftAnchor, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configureUI(){
        guard let vm = self.viewModel else {return}
        let likeButtonImage = UIImage(named: vm.likeButtonImageName)?.withRenderingMode(.alwaysOriginal)
        self.likeButton.setImage(likeButtonImage, for: .normal)
        
        guard let urls =  vm.imageUrl else { return }
        slideShow.contentScaleMode = .scaleAspectFill
        let pageIndicator = UIPageControl()
        pageIndicator.pageIndicatorTintColor = UIColor.customblack
        let source = urls.map { AlamofireSource(url: $0) }
        slideShow.setImageInputs(source)
    }
    //MARK: - Selectors
    @objc func handleDismissDetailPage(){
        delegate?.handleDismissDetailPage()
        
    }
    @objc func handleLikeButtonTapped(){
        delegate?.handleLikeRestaurant()
    }
    
    @objc func handleShareButtonTapped(){
        delegate?.handleShareRestaurant()
    }
}
