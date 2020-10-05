//
//  ActionSheetLauncher.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/16.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let collectionViewCellID = "priceIdentifier"
private let tableViewCellID = "sortIdentifier"
private let priceRangeHeader = "headerIdentifier"
private let priceRangeFooter = "footerIdentifier"

protocol ActionSheetLauncherDelegate : class {
    func didSelectSortOption(shouldAdd: Bool, option: SortOption)
}

class ActionSheetLauncher : NSObject {
    //MARK: - Properties
    private var window : UIWindow?
    weak var delegate : ActionSheetLauncherDelegate?
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isScrollEnabled = false
        cv.layer.cornerRadius = 32
        return cv
    }()
    
    private let tableView =  UITableView()
    
    private lazy var blackView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    private let sortOptionHeader : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "Sort"
        label.font = UIFont.arialBoldMT
        view.setDimension(width: 500, height: 24 + 20 + 8)
        view.addSubview(label)
        label.anchor(bottom: view.bottomAnchor, paddingBottom: 8, height: 24)
        return view
    }()
    private let notchView : UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.setDimension(width: 50, height: 5)
        return view
    }()
    private var selectedOptionIndexPath =  IndexPath(row: 0, section: 0) { didSet{ self.tableView.reloadData()} }
    private var selectedPriceIndexPath =  [IndexPath]() { didSet{ self.collectionView.reloadData()}}
    private var isPriceSheetFold = true
    private var isSortSheetFold = true
    //MARK: - Lifecycle
    override init() {
        super.init()
        configureCollecionView()
        configureTableView()
    }
    
    //MARK: - Helpers
    func show(isSortButton: Bool){
        print("DEBUG: Show action sheet ... ")
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        if isSortButton {
            window.addSubview(tableView)
            tableView.frame = CGRect(x: 0, y: window.frame.height,
                                          width: window.frame.width, height: 276)
            window.addSubview(notchView)
            notchView.centerX(inView: window)
            notchView.anchor(top: tableView.topAnchor, paddingTop: 7)
            
            
        }else {
            window.addSubview(collectionView)
            collectionView.frame = CGRect(x: 0, y: window.frame.height,
                                          width: window.frame.width, height: 260)
        }
        
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            if isSortButton {
                self.isSortSheetFold = false
                self.tableView.frame.origin.y -= 276
            }else{
                self.isPriceSheetFold = false
                self.collectionView.frame.origin.y -= 260
            }
        }
    }
    
    func configureCollecionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PriceRangeCell.self, forCellWithReuseIdentifier: collectionViewCellID)
        collectionView.register(PriceRangeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: priceRangeHeader)
        collectionView.register(PriceRangeFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: priceRangeFooter)
    }
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 48
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 32
        tableView.register(SortOptionCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    //MARK: - Selectors
    @objc func handleDismissal(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if !self.isSortSheetFold {
                self.isSortSheetFold = true
                self.tableView.frame.origin.y += 276
            } else if !self.isPriceSheetFold{
                self.isPriceSheetFold = true
                self.collectionView.frame.origin.y += 260
            }
        }
    }
}

extension ActionSheetLauncher : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath)
        as! PriceRangeCell
        cell.numOfPrice = indexPath.row + 1
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: priceRangeHeader, for: indexPath) as! PriceRangeHeader
             return header
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: priceRangeFooter, for: indexPath) as! PriceRangeFooter
            return footer
        }
    }
}
extension ActionSheetLauncher : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let window = window else { return CGSize() }
        return CGSize(width: window.frame.width, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let window = window else { return CGSize() }
        return CGSize(width: window.frame.width , height: 48 + 32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let window = window else { return UIEdgeInsets() }
        
        let horizontalInset = (window.frame.width - (72*4 + 16*3))/2
        return UIEdgeInsets(top: 32, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
}

extension ActionSheetLauncher: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SortOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath)
        as! SortOptionCell
        cell.option = SortOption(rawValue: indexPath.row)
        cell.selectionStyle = .none
        if indexPath == self.selectedOptionIndexPath {
            cell.isSelected = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sortOptionHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = SortOption(rawValue: indexPath.row) else { return }
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        
        self.selectedOptionIndexPath = selectedIndexPath
    }
}

class PriceRangeHeader: UICollectionReusableView {
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        label.text = "Price Range"
        return label
    }()
    private let notchView : UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.setDimension(width: 50, height: 5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(notchView)
        notchView.anchor(top:topAnchor, paddingTop: 7)
        notchView.centerX(inView: self)
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 20, paddingLeft: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PriceRangeFooter: UICollectionReusableView {
    private var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ctaYActive")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(applyButton)
        applyButton.anchor(bottom: bottomAnchor, width: 336, height: 48)
        applyButton.centerX(inView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
