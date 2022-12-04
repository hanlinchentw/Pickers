//
//  MenuButton.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		var configuration = UIButton.Configuration.filled()
		configuration.buttonSize = .small
		configuration.cornerStyle = .capsule
		configuration.imagePadding = 8
		configuration.imagePlacement = .trailing
		configuration.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 8)
		configuration.image = UIImage(named: "icnArrowDropDown")
		
		configuration.title = "Menu"
		configuration.attributedTitle = .init("Menu", attributes: .init(.arial14))
		configuration.baseBackgroundColor = .white
		configuration.baseForegroundColor = .black
		self.configuration = configuration
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setMenuChildren(_ menuChildren: Array<UIAction>) {
		self.showsMenuAsPrimaryAction = true
		self.menu = UIMenu(children: menuChildren)
	}
}
