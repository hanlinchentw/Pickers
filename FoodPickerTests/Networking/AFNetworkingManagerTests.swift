//
//  AFNetworkingManagerTests.swift
//  FoodPickerTests
//
//  Created by 陳翰霖 on 2023/4/1.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import XCTest
import Alamofire

@testable import FoodPicker

protocol AFNetworkingManagerTestSpec {
	func test_with_200_statuscode_success_response_without_error() async throws
	func test_with_invalid_url_should_throw_error() async
	func test_with_invalid_status_code_should_throw_error() async
	//
}

final class AFNetworkingManagerTests: XCTestCase, AFNetworkingManagerTestSpec {
	private let API_ENDPOINT = "https://api.yelp.com/v3"
	var url: URL!
	var configuration: URLSessionConfiguration!
	var sut: AFNetworkingManager!
	
	override func setUp() {
		configuration = URLSessionConfiguration.af.ephemeral
		configuration.protocolClasses! = [MockURLProtocol.self]
		sut = AFNetworkingManager.shared
		url = URL(string: API_ENDPOINT)!
	}
	
	override func tearDown() {
		configuration = nil
		MockURLProtocol.mockResponseHandler = nil
		sut = nil
		url = nil
	}
	
	func test_with_200_statuscode_success_response_without_error() async throws {
		guard let businessStaticData = BusinessStub.staticBusinessesData else {
			XCTFail("StaticBusinesses doesn't exist.")
			return
		}
		
		MockURLProtocol.mockResponseHandler = {
			let response = HTTPURLResponse(url: self.url,
																		 statusCode: 200,
																		 httpVersion: nil,
																		 headerFields: nil)
			return (response!, businessStaticData)
		}
		
		let responseData = try await sut.request(configuration, url: API_ENDPOINT, parameters: [:])
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let decoded_response_data = try decoder.decode([Business].self, from: responseData)
		let decoded_static_data = try decoder.decode([Business].self, from: businessStaticData)
		
		XCTAssert(decoded_response_data == decoded_static_data)
	}
	
	func test_with_invalid_url_should_throw_error() async {
		do {
			let INVALID_URL = "invalid url"
			let _ = try await sut.request(configuration, url: INVALID_URL, parameters: [:])
			XCTFail("Test should failed already.")
		} catch {
			guard let error = error as? NetworkingError else {
				XCTFail("Cast error, error type should be NetworkingError.")
				return
			}
			XCTAssert(error == NetworkingError.invalidUrl)
		}
	}
	
	func test_with_invalid_status_code_should_throw_error() async {
		do {
			MockURLProtocol.mockResponseHandler = {
				let response = HTTPURLResponse(url: self.url,
																			 statusCode: 400,
																			 httpVersion: nil,
																			 headerFields: nil)
				return (response!, nil)
			}
			
			let _ = try await sut.request(configuration, url: API_ENDPOINT, parameters: [:])
			XCTFail("Test should failed already.")
		} catch {
			guard let error = error as? NetworkingError else {
				XCTFail("Cast error, error type should be NetworkingError.")
				return
			}
			XCTAssert(error == NetworkingError.invalidStatusCode(statusCode: 400))
		}
	}
	
}

extension AFNetworkingManagerTests {
	final class BusinessStub {
		static var staticBusinessesData: Data? {
			if let path = Bundle.main.path(forResource: "StaticBusinesses", ofType: "json"),
				 let staticData = FileManager.default.contents(atPath: path) {
				return staticData
			}
			return nil
		}
	}
}
