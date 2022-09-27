//
//  EditListError.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

// MARK: - Edit list error
extension BottomSheetViewModel {
	enum EditListError: Error {
		case updateEmptyList(delete: () -> Void)
		case saveEmptyList
		case listHaveNoName
		
		var alertModel: AlertPresentationModel {
			switch self {
			case .updateEmptyList(let delete):
				return .init(title: "Empty List",  content: "Empty List will be deleted.", rightButtonText: "Delete", leftButtonText: "Cancel", rightButtonOnPress: {
					delete()
				})
			case .listHaveNoName:
				return .init(title: "Please give me a name 🥺", rightButtonText: "OK")
			case .saveEmptyList:
				return .init(title: "Empty",  content: "Select at least one restaurant", rightButtonText: "OK")
			}
		}
	}
}
