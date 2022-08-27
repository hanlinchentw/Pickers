//
//  MockedList.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/27.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class MockedList {
  static let mock_list_1 = List(id: "123", date: "1249019501", name: "MOCK_1", context: CoreDataManager.sharedInstance.managedObjectContext)
  static let mock_list_2 = List(id: "123", date: "1249019121", name: "MOCK_2", context: CoreDataManager.sharedInstance.managedObjectContext)
  static let mock_list_3 = List(id: "123", date: "1249011124", name: "MOCK_3", context: CoreDataManager.sharedInstance.managedObjectContext)

  static let mock_lists = [mock_list_1, mock_list_2, mock_list_3]
}
