//
//  NetworkService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/14.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

enum URLRequestError: Error {
  case noInternet
  case serverFailure
  case clientFailure
  case noResponse(message: String)
}

protocol NetworkProvider {
  var baseURL: String { get }
  var headers: HTTPHeaders? { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: [String: Any] { get }
}

class NetworkService {
  typealias DataResponseHandler = ((AFDataResponse<Data?>) -> Void)

  static func createHttpRequest(service: NetworkProvider) -> DataRequest {
    let urlPath = URL(string: "\(service.baseURL)\(service.path)")!
    return AF.request(urlPath, method: service.method, parameters: service.parameters, headers: service.headers)
  }

  static func requestWithCompletion(service: NetworkProvider, completion: @escaping DataResponseHandler) {
    let request = NetworkService.createHttpRequest(service: service)
    request.response(completionHandler: completion)
  }
  static func requestWithSingleResponse(service: NetworkProvider) -> Single<Data?> {
    return Single<Data?>.create { (singleEvent) -> Disposable in
      NetworkService.requestWithCompletion(service: service) { response in
        switch response.result {
        case .success:
          singleEvent(.success(response.data))
        case .failure(let error):
          singleEvent(.failure(error))
        }
      }
      return Disposables.create()
    }
  }

}
