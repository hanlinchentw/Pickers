//
//  EditListView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import Combine

struct EditListView: View {
	@Environment(\.managedObjectContext) var viewContext
	@Environment(\.presentationMode) var presentationMode
	
	let list: List
	@ObservedObject var viewModel = EditListViewModel()
	@ObservedObject var keyboardHelper = KeyboardHelper()
	
	var body: some View {
		ZStack {
			Color.listViewBackground
			
			VStack {
				EditListHeader(leftButtonOnPress: goBack, rightButtonOnPress: delete)
				VStack {
					EditNameContainer(editListName: $viewModel.editListName)
					EditListContainer(restaurants: $viewModel.viewObjects)
						.environment(\.managedObjectContext, viewContext)
				}
				.padding(.vertical, 16)
				.background(Color.white)
				
				Spacer()
			}
			.padding(.top, SafeAreaUtils.top)
			
			VStack {
				Spacer()
				TwoHorizontalButton(
					leftButtonText: "Cancel",
					rightButtonText: "Save",
					rightButtonDisabled: viewModel.saveButtonDisabled,
					buttonSize: .init(width: 160, height: 48),
					onPressLeftButton: goBack,
					onPressRightButton: { viewModel.saveList(completion: goBack) }
				)
				.padding(.top, 16)
				.background(Color.listViewBackground)
			}
			.animation(.easeInOut, value: keyboardHelper.height)
			.offset(y: -keyboardHelper.height)
		}
		.showAlert(
			when: viewModel.alert != nil,
			alert: { Alert(model: mapAlertModelFromAlertType(alertType: viewModel.alert!)) }
		)
		.onAppear { viewModel.setInitialValue(list: list) }
		.onTapToResign()
		.ignoresSafeArea()
		.navigationBarHidden(true)
	}
}

struct EditListView_Previews: PreviewProvider {
	static var previews: some View {
		EditListView(list: MockedList.mock_list_1)
	}
}

extension EditListView {
	var goBack: () -> Void {
		{
			presentationMode.wrappedValue.dismiss()
		}
	}
	
	var delete: () -> Void {
		{ viewModel.alert = .deleteList }
	}
}

extension EditListView {
	func mapAlertModelFromAlertType(alertType: EditListViewModel.EditAlertType) -> AlertPresentationModel {
		switch alertType {
		case .emptyList:
			return emptyListAlertModel
		case .deleteList:
			return deleteListAlertModel
		}
	}
	
	var emptyListAlertModel: AlertPresentationModel {
		return .init(
			title: "Empty list will be deleted",
			rightButtonText: "Delete",
			leftButtonText: "Cancel",
			rightButtonOnPress: {
				list.delete(in: viewContext)
				try? viewContext.save()
				presentationMode.wrappedValue.dismiss()
			},
			leftButtonOnPress: {
				viewModel.alert = nil
			}
		)
	}
	
	var deleteListAlertModel: AlertPresentationModel {
		return .init(
			title: "Delete List",
			content: "Do you want to delete “\(list.name)” from your saved list?",
			rightButtonText: "Delete",
			leftButtonText: "Cancel",
			rightButtonOnPress: {
				list.delete(in: viewContext)
				try? viewContext.save()
				goBack()
			},
			leftButtonOnPress: {
				viewModel.alert = nil
			}
		)
	}
}
