//
//  RestaurantPresenterTests.swift
//  FoodPickerTests
//
//  Created by 陳翰霖 on 2022/10/1.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import XCTest
import CoreLocation
@testable import FoodPicker

final class RestaurantPresenterTests: XCTestCase {
	func test_with_restaurant_view_object_without_actionBtnMode() {
		let viewObject = RestaurantViewObject(business: Self.TEST_BUSINESS_1)
		let presenter = RestaurantPresenter(restaurant: viewObject, actionButtonMode: .none)
		XCTAssert(presenter.name == "Louisa")
		XCTAssert(presenter.imageUrl == "https://pixy.org/src/31/316448.png")
		XCTAssert(presenter.actionButtonImage == "")
		XCTAssert(presenter.distanceFromCurrentLocation == 1000)
		XCTAssert(presenter.priceCategoryDistanceText == "$・Cafe・1000 m")
		XCTAssert(presenter.ratingAndReviewCountString.string == "★ 4.8 (15+)")
	}
}

extension RestaurantPresenterTests {
	static let TEST_BUSINESS_1 = Business(
		id: "1",
		name: "Louisa",
		rating: 4.8,
		price: "$",
		imageUrl: Constants.defaultImageURL,
		distance: 200,
		isClosed: false,
		categories: [Categories.init(title: "Cafe")],
		reviewCount: 15,
		coordinates: CLLocationCoordinate2D(latitude: 25, longitude: 121)
	)
}
