//
//  ActionSheetLauncher.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/9/16.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit

private let priceRangeCellIdentifier = "priceIdentifier"
private let sortOptionCellIdentifier = "sortIdentifier"
private let tableViewCellID = "sortIdentifier"
private let sheetHeaderIdentifier = "headerIdentifier"
private let sheetFooterIdentifier = "footerIdentifier"

protocol ActionSheetLauncherDelegate: AnyObject{
    func didTapFilterCell(sortOption: SortOption)
    func didTapApplyButton(priceRange: [PriceRange])
}

enum SheetMode{
    case sort
    case price
    
    var description: String {
        switch self {
        case .sort: return "Sort"
        case .price: return "Price Range"
        }
    }
}

class ActionSheetLauncher: NSObject {
    //MARK: - Properties
    private var window: UIWindow?
    weak var delegate: ActionSheetLauncherDelegate?
    let mode: SheetMode
    private var collectionView: UICollectionView?
    private lazy var blackView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    private let sheetHeight : CGFloat = 256
    var selectedIndexPath : Set<IndexPath> = Set<IndexPath>()
    var selectedSortOption: SortOption?
    //MARK: - Lifecycle
    init(mode: SheetMode) {
        self.mode = mode
        super.init()
        window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if mode == .sort { configureSortSheet() }
        else { configurePriceSheet() }
        configureCollectionView()
    }
    //MARK: - Helpers
    func configureSortSheet() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.allowsMultipleSelection = false
        collectionView?.register(SortOptionCell.self, forCellWithReuseIdentifier: sortOptionCellIdentifier)
    }
    func configurePriceSheet(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView?.allowsMultipleSelection = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PriceRangeCell.self, forCellWithReuseIdentifier: priceRangeCellIdentifier)
    }
    func configureCollectionView(){
        collectionView?.isScrollEnabled = false
        collectionView?.backgroundColor = .white
        collectionView?.layer.cornerRadius = 12
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let window = window else { return }
        collectionView?.frame = CGRect(x: 0, y: window.frame.height,
                                      width: window.frame.width, height: sheetHeight)
        collectionView?.register(SheetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sheetHeaderIdentifier)
        collectionView?.register(SheetFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: sheetFooterIdentifier)
    }
    func animateIn(sortOption: SortOption? = nil, priceRange: [PriceRange] = []){
        guard let window = window,
              let collectionView = self.collectionView else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(collectionView)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            collectionView.transform = CGAffineTransform(translationX: 0, y: -self.sheetHeight)
        }
    }
    func animateOut(){
        guard let collectionView = self.collectionView else { return }
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            collectionView.transform = .identity
        }
    }
    //MARK: - Selectors
    @objc func handleDismissal(){
        animateOut()
    }
}
//MARK: - UICollectionViewDelegate UICollectionViewDataSource
extension ActionSheetLauncher : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode == .sort ? 3 : 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if mode == .sort{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sortOptionCellIdentifier, for: indexPath) as! SortOptionCell
            cell.option = SortOption(rawValue: indexPath.row)
            if let selectedOption = self.selectedSortOption,
                cell.option == selectedOption {
                cell.isSelected = true
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: priceRangeCellIdentifier, for: indexPath) as! PriceRangeCell
            cell.priceRange = PriceRange(rawValue: indexPath.row)
            let isSelected = selectedIndexPath.contains(indexPath)
            cell.isChosen = isSelected
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sheetHeaderIdentifier, for: indexPath) as! SheetHeader
            header.configureTitle(title: mode.description)
             return header
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sheetFooterIdentifier, for: indexPath) as! SheetFooter
            footer.delegate = self
            return footer
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mode == .sort {
//            guard let cell = collectionView.cellForItem(at: indexPath) as? SortOptionCell else { return }
            delegate?.didTapFilterCell(sortOption: SortOption(rawValue: indexPath.row) ?? .nearby)
            self.selectedSortOption = SortOption(rawValue: indexPath.row)
            self.collectionView?.reloadData()
        }else{
            guard let cell = collectionView.cellForItem(at: indexPath) as? PriceRangeCell else { return }
            cell.isChosen.toggle()
            if cell.isChosen {
                self.selectedIndexPath.insert(indexPath)
            }else{
                self.selectedIndexPath.remove(indexPath)
            }
            print(self.selectedIndexPath)
        }
    }
}
extension ActionSheetLauncher : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = mode == .sort ? CGSize(width: 100, height: 48) : CGSize(width: 72, height: 72)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let window = window, self.mode == .price else { return CGSize() }
        return CGSize(width: window.frame.width, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let window = window, self.mode == .price else { return CGSize() }
        return CGSize(width: window.frame.width , height: 48 + 32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let window = window else { return UIEdgeInsets() }
        let horizontalInset = (window.frame.width - (72*4 + 16*3))/2
        return UIEdgeInsets(top: 32, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
}

//MARK: - SheetFooterDelegate
extension ActionSheetLauncher: SheetFooterDelegate {
    func didTapApplyButton() {
        let selectedRange = self.selectedIndexPath.compactMap{PriceRange(rawValue: $0.row)}
        delegate?.didTapApplyButton(priceRange: selectedRange)
        animateOut()
    }
}
