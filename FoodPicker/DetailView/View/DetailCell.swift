//
//  DetailScrollView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/25.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import MapKit


class DetailCell : UICollectionViewCell {
	//MARK: - Properties
	weak var delegate : DetailCellDelegate?
	var presenter: DetailRowPresenter? { didSet{ configureCellInformation() }}
	
	private let iconImageView : UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFit
		return iv
	}()
	private let titleLabel : UILabel = {
		let label = UILabel()
		label.font = UIFont.arial16BoldMT
		label.textColor = .black
		label.numberOfLines = 0
		label.adjustsFontSizeToFitWidth = true
		return label
	}()
	
	private let contentLabel : UILabel = {
		let label = UILabel()
		label.font = UIFont.arial14MT
		label.numberOfLines = 0
		label.textColor = .black
		label.adjustsFontSizeToFitWidth = true
		return label
	}()
	private let rightTextLabel = UILabel()
	
	private lazy var actionButton : UIImageView = {
		let view = UIImageView()
		view.layer.masksToBounds = false
		view.layer.shadowColor = UIColor(white: 0, alpha: 0.7).cgColor
		view.layer.shadowOpacity = 0.3
		view.layer.shadowOffset = CGSize(width: 0, height: 0)
		view.layer.shadowRadius = 3
		
		let shadowView = UIView()
		shadowView.backgroundColor = .clear
		shadowView.layer.cornerRadius = 12
		shadowView.layer.masksToBounds = true
		
		view.addSubview(shadowView)
		shadowView.fit(inView: view)
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleActionButtonTapped))
		view.addGestureRecognizer(tap)
		view.isUserInteractionEnabled = true
		return view
	}()
	//MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	//MARK: - Selectors
	@objc func handleActionButtonTapped(){
		presenter?.actionButtonTapped()
	}
	//MARK: - Helpers
	func configureCellInformation(){
		guard let presenter = presenter else {
			contentLabel.text = "No Providing"
			return
		}
		titleLabel.text = presenter.title
		contentLabel.attributedText = presenter.content
		
		iconImageView.isHidden = presenter.iconIsHidden
		actionButton.isHidden = presenter.actionButtonIsHidden
		
		iconImageView.image = UIImage(named: presenter.icon ?? "")
		actionButton.image = UIImage(named: presenter.actionButtonImageName ?? "")
	}
}
//MARK: - Auto layout
extension DetailCell {
	fileprivate func configureUI() {
		backgroundColor = .white
		let titleStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
		titleStack.axis = .horizontal
		titleStack.spacing = 8
		
		
		
		addSubview(titleStack)
		titleStack.anchor(top:topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		titleLabel.setDimension(width: UIScreen.screenWidth - 32)
		
		addSubview(actionButton)
		actionButton.anchor(top:topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 16)
		
		addSubview(contentLabel)
		contentLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor,
												paddingTop: 12, paddingLeft: 16, paddingRight: 64, paddingBottom: 12)
		
		addSubview(rightTextLabel)
		rightTextLabel.anchor(right: rightAnchor, paddingRight: 12)
		rightTextLabel.centerY(inView: titleLabel)
	}
}
