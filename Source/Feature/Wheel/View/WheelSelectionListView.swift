//
//  WheelSelectionListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/9/3.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

protocol WheelSelectionListViewDelegate: AnyObject {
  var items: [PlaceViewModel] { get }
}

final class WheelSelectionListView: UITableViewController {
  weak var delegate: WheelSelectionListViewDelegate?

  init(delegate: WheelSelectionListViewDelegate? = nil) {
    super.init(style: .plain)
    self.delegate = delegate
    addHeader()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    tableView.register(cellType: WheelSelectionListViewCell.self)
    tableView.rowHeight = 100
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func refresh() {
    tableView.reloadData()
  }

  func addHeader() {
    let header = UILabel()
    header.text = "What's in the wheel?"
    header.bold(size: 14)
    header.textColor = .darkGray
    tableView.tableHeaderView = header
  }
}

extension WheelSelectionListView {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    delegate?.items.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as WheelSelectionListViewCell
    if let vm = delegate?.items[safe: indexPath.row] {
      cell.configure(viewModel: vm)
    }
    cell.selectionStyle = .none
    return cell
  }
}
