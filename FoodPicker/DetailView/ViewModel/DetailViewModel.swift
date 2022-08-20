//
//  DetailViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class DetailViewModel {
  @Inject var selectedCoreService: SelectedCoreService
  @Inject var likedCoreService: LikedCoreService

  let id: String
  @Published var detail: Detail? = nil
  @Published var isLiked: Bool = false
  @Published var isSelected: Bool = false
  @Published var isExpanded = false

  init(restaurantId: String) {
    self.id = restaurantId
  }
}

extension DetailViewModel {
  func refresh() {
    self.isSelected = try! selectedCoreService.exists(id: self.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    self.isLiked = try! likedCoreService.exists(id: self.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    self.fetchDetail()
  }

  func selectButtonTapped() {
    if isSelected {
      try! selectedCoreService.deleteRestaurant(id: self.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    } else {
      try! selectedCoreService.addRestaurant(data: ["id": id], in: CoreDataManager.sharedInstance.managedObjectContext)
    }
    isSelected.toggle()
  }

  func likedButtonTapped() {
    if isLiked {
      try! likedCoreService.deleteRestaurant(id: self.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    } else {
      try! likedCoreService.addRestaurant(data: ["id": id], in: CoreDataManager.sharedInstance.managedObjectContext)
    }
    isLiked.toggle()
  }

  func expandButtonTapped() {
    self.isExpanded.toggle()
  }
}

extension DetailViewModel {
  func fetchDetail() {
    MBProgressHUDHelper.showLoadingAnimation()
    Task {
      do {
        let detail = try await BusinessService.fetchDetail(id: self.id)
        self.detail = detail
        MBProgressHUDHelper.hideLoadingAnimation()
      } catch {
        print("fetchDetail.failed >>> \(error.localizedDescription)")
        MBProgressHUDHelper.hideLoadingAnimation()
      }
    }
  }
}
