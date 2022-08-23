//
//  EditFavoriteListUsecase.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/23.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import CoreData
import SwiftUI

final class EditFavoriteListUsecase: ObservableObject {
  @Inject var likedCoreService: LikedCoreService

  @Published var isEditing: Bool = false
  @Published var deletedItem: Restaurant? = nil

  var deletionAlertText: String {
    return "Do you want to remove \(deletedItem!.name)?"
  }
  
  var setDeleteItem: (_ restaurant: Restaurant) -> Void {
    return { restaurant in
      self.deletedItem = restaurant
    }
  }

  var removeItemFromFavorite: () -> Void {
    return {
      try? self.likedCoreService.deleteRestaurant(id: self.deletedItem!.id, in: CoreDataManager.sharedInstance.managedObjectContext)
      self.deletedItem = nil
    }
  }

  var cancelDeletion: () -> Void {
    return {
      self.deletedItem = nil
    }
  }
}
