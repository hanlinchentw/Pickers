//
//  PlaceVO.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/3/14.
//

import Foundation
import SwiftData

@Model
final class PlaceVO: Identifiable {
	var id: String
	var name: String

	var imageURL: URL?
	var location: String?

	init(id: String, name: String) {
		self.id = id
		self.name = name
	}

	init(from place: Place) {
		self.id = place.id
		self.name = place.name
		self.imageURL = place.imageURL
		self.location = place.address
	}
}
