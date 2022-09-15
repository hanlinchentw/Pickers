//
//  EditListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class EditListViewModel: ObservableObject {
  @Published var list: List
  @Published var editListName: String = ""

  init(list: List) {
    self.list = list
    self.editListName = list.name
  }

  
}
