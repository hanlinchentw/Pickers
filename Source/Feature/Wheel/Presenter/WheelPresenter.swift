//
//  WheelPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/29.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import SwiftData
import SwiftUI

protocol WheelPresenting: AnyObject {}

protocol WheelView: AnyObject where Self: UIViewController {
  func refreshView()
}

final class WheelPresenter: WheelPresenting {
  var wheelItems: [WheelItem] = WheelItem.dummyItems
//  var selectionStore: PlacesSelectionStore
  var interactor: WheelInteractor?
  weak var view: WheelView?
  var isPresentingList = false
  var lists: [SDListModel] = []

  var numOfLists: Int {
    lists.count + 1 // add 1 for Create List Cell
  }

  func onViewDidLoad() {
    fetchLists()
  }

  func refreshWheel() {
//    if selectionStore.selectedPlaces.isEmpty {
//      wheelItems = WheelItem.dummyItems
//      return
//    }
//    wheelItems = selectionStore.selectedPlaces.enumerated().map {
//      WheelItem(id: $1.id, title: $1.name, titleColor: $0 % 2 == 0 ? .customblack : .white, itemColor: $0 % 2 == 0 ? .white : .black)
//    }
  }

  func onSelectListCell(indexPath: IndexPath) {
    if indexPath.row == 0 {
      onCreateList()
    }
  }

  func onCreateList() {
    let alert = UIAlertController(title: "Create List", message: "Naming your bucket list! 🤤", preferredStyle: .alert)
    alert.addTextField { tf in
      tf.placeholder = "My Favorite, Working place lunch..."
      // TODO: Error Handling
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
    alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
      guard let self else { return }
      try? interactor?.createEmptyList(name: alert.textFields?[0].text ?? "")
      fetchLists()
      view?.refreshView()
    }))
    view?.present(alert, animated: true)
  }

  func fetchLists() {
    lists = (try? interactor?.fetchLists()) ?? []
  }

  func listViewModel(indexPath: IndexPath) -> ListShortcutViewModel {
    let list = lists[indexPath.row - 1]
    return ListShortcutViewModel(id: list.id, name: list.name)
  }
}

extension WheelPresenter: WheelDelegate, WheelDataSource {
  func wheelDidChangeValue(_: Int) {}

  func onClickItem(id: String) {
  }

  func numberOfSections() -> Int {
    wheelItems.count
  }

  func itemsForSections() -> [WheelItem] {
    wheelItems
  }
}

extension WheelPresenter: WheelSelectionListViewDelegate {
  var items: [PlaceViewModel] {
//    selectionStore.selectedPlaces
    []
  }
}
