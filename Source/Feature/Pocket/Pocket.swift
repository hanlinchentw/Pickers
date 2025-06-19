//
//  Pocket.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/6/19.
//

import Foundation

struct Pocket: Identifiable, Equatable {
	let id: String
	let name: String
	var places: [Place] = []
	let createdTime: Date = Date()
}

