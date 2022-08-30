//
//  DetailViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

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
  @MainActor
  func refresh() {
    self.isSelected = try! selectedCoreService.exists(id: self.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    self.isLiked = try! likedCoreService.exists(id: self.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    self.fetchDetail()
  }

  func selectButtonTapped() {
    print("selectButtonTapped")
    guard let detail = detail else {
      return
    }
    let restaurant: Restaurant = .init(detail: detail)
    if isSelected {
      try! selectedCoreService.deleteRestaurant(id: restaurant.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    } else {
      try! selectedCoreService.addRestaurant(data: ["restaurant": restaurant], in: CoreDataManager.sharedInstance.managedObjectContext)
    }
    isSelected.toggle()
  }

  func likeButtonTapped() {
    guard let detail = detail else {
      return
    }
    let restaurant: Restaurant = .init(detail: detail)
    if isLiked {
      try! likedCoreService.deleteRestaurant(id: restaurant.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    } else {
      try! likedCoreService.addRestaurant(data: ["restaurant": restaurant], in: CoreDataManager.sharedInstance.managedObjectContext)
    }
    isLiked.toggle()
  }

  func shareButtonTapped() {
    let activityViewController = UIActivityViewController(activityItems: [detail?.name, detail?.url], applicationActivities: nil)
    OperationQueue.main.addOperation {
      PresentHelper.topViewController?.present(activityViewController, animated: true, completion: nil)
    }
  }

  func expandButtonTapped() {
    self.isExpanded.toggle()
  }
}

extension DetailViewModel {
  @MainActor
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
