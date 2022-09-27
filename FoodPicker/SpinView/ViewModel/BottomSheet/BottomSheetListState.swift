//
//  BottomSheetHeaderState.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

// MARK: - ListState
extension BottomSheetViewModel {
	enum ListState: Int {
		case temp
		case existed
		case edited
	}
}
// MARK: - UI Properties
extension BottomSheetViewModel {
	var listName: String {
		switch listState {
		case .temp: return "My selected list"
		case .existed: return list!.name
		case .edited:
			let ns = NSMutableAttributedString(string: list!.name, attributes: .attributes([.arial16Bold, .black]))
			ns.append(NSAttributedString(string: " *", attributes: .butterScotch))
			return ns.string
		}
	}
	
	var saveButtonText: String? {
		switch listState {
		case .temp: return "Save list"
		case .existed: return nil
		case .edited: return "Save as new"
		}
	}
	
	var saveButtonHidden: Bool {
		switch listState {
		case .temp: return false
		case .existed: return true
		case .edited: return false
		}
	}
	
	var updateButtonHidden: Bool {
		switch listState {
		case .temp: return true
		case .existed: return true
		case .edited: return false
		}
	}
}
