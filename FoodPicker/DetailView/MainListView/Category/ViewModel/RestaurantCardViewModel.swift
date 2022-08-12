//
//  RestaurantCardViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/10.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

struct RestaurantCardViewModel: ViewModelType {
  typealias Input = RestaurantCardViewModelInput
  typealias Output = RestaurantCardViewModelOutput

  struct RestaurantCardViewModelInput {
    let likeButtonTapped: AnyObserver<Void>
    let selectButtonTapped: AnyObserver<Void>
  }

  struct RestaurantCardViewModelOutput {
    var isLiked: Observable<Bool>
    var isSelected: Observable<Bool>
  }

  var inputs: Input
  var outputs: Output

  // inputs
  private let likeButtonTapped = PublishSubject<Void>()
  private let selectButtonTapped = PublishSubject<Void>()

  init(restaurant: RestaurantViewObject) {
    @Inject var likedRestaurantCoreService: LikedRestaurantCoreService
    @Inject var selectedRestaurantCoreService: SelectedRestaurantCoreService

    let isLiked: Observable<Bool> = likeButtonTapped.map { _ -> Bool in
      let previosIsLiked = try likedRestaurantCoreService.checkIfRestaurantExists(id: restaurant.id)
      return !previosIsLiked
    }

    let isSelected: Observable<Bool> = likeButtonTapped.map { _ in
      let isAlreadSelected = try selectedRestaurantCoreService.checkIfRestaurantExists(id: restaurant.id)
      if isAlreadSelected {

      } else {

      }
      return !isAlreadSelected
    }

    inputs = Input.init(likeButtonTapped: likeButtonTapped.asObserver(), selectButtonTapped: selectButtonTapped.asObserver())
    outputs = Output.init(isLiked: isLiked.asObservable(), isSelected: isSelected.asObservable())
  }
}
