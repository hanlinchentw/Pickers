//
//  SearchHeader.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/5/17.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import UIKit

protocol SearchHeaderDelegate: AnyObject {
    func didTapSearchHeader()
    func didClearSearchHeader()
}
class SearchHeader: UICollectionReusableView {
    //MARK: - Properties
    lazy var searchBar : UITextField = {
        let bar = UITextField().createSearchBar(withPlaceholder: "Search for food or categories")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapSearchBar))
        bar.addGestureRecognizer(tap)
        bar.isUserInteractionEnabled = true
        bar.clearButtonMode = .whileEditing
        return bar
    }()
    weak var delegate : SearchHeaderDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        searchBar.delegate = self
        addSubview(searchBar)
        searchBar.anchor(left: leftAnchor, right: rightAnchor,
                         paddingLeft: 16, paddingRight: 16, height: 40)
        searchBar.centerY(inView: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleTapSearchBar(){
        delegate?.didTapSearchHeader()
    }
}
extension SearchHeader: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.didClearSearchHeader()
        return false
    }
}
