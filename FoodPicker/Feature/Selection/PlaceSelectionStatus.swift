//
//  PlaceSelectionStatus.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

enum PlaceSelectionStatus {
	case draft([PlaceViewModel])
	case active(PlacePocketViewModel, original: PlacePocketViewModel)

	var isEdited: Bool {
		if case .active(let viewModel, let original) = self {
			return viewModel == original
		}
		return false
	}
}
