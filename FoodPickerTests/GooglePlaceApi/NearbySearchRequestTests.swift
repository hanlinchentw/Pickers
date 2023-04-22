//
//  NearbySearchRequest.swift
//  FoodPickerTests
//
//  Created by 陳翰霖 on 2023/4/22.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import XCTest
import APIKit
@testable import FoodPicker

final class NearbySearchRequestTests: XCTestCase {
	var adapter: TestSessionAdapter!
	var request: NearbySearchRequest!
	var session: Session!
	
	override func setUp() {
		super.setUp()
		self.adapter = TestSessionAdapter()
		self.request = NearbySearchRequest(keyword: "food", latitude: 25.133, longitude: 121.1)
		self.session = Session(adapter: adapter)
	}
	
	func testSuccess() throws {
		guard let data = StaticJsonFileReader.read("Place") else {
			XCTFail("Place.json not found")
			return
		}
		adapter.data = data
		
		let expectation = self.expectation(description: "wait for response")
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let expected = try decoder.decode(PlaceApiResponse.self, from: data)
		
		session.send(request) { result in
			switch result {
			case .success(let response):
				XCTAssert(expected.nextPageToken == response.nextPageToken)
				XCTAssert(expected.results == response.results)
			case .failure:
				XCTFail()
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1.0, handler: nil)
	}
}
