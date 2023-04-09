//
//  MockURLProtocol.swift
//  FoodPickerTests
//
//  Created by 陳翰霖 on 2023/4/1.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

class MockURLProtocol: URLProtocol {
	static var mockResponseHandler: (() -> (HTTPURLResponse, Data?))?
	
	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}
	
	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}
	
	override func startLoading() {
		
		guard let handler = MockURLProtocol.mockResponseHandler else {
			fatalError("Loading handler is not set.")
		}
		
		let (response, data) = handler()
		client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		if let data = data {
			client?.urlProtocol(self, didLoad: data)
		}
		client?.urlProtocolDidFinishLoading(self)
	}
	
	override func stopLoading() {
		
	}
}
