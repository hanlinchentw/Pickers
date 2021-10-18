//
//  NetworkService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/14.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Moya

typealias restaurantResponse = ([Restaurant]?,URLRequestFailureResult?) -> Void
typealias detailResponse = (Details?,URLRequestFailureResult?) -> Void


enum URLRequestFailureResult : Int ,Error {
    case noInternet
    case serverFailure
    case clientFailure
}

class  NetworkService {
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    static let shared = NetworkService()
    func fetchRestaurants(lat: Double, lon: Double,
                          withOffset offset: Int = 0,
                          option: recommendOption? = nil, limit: Int,
                          completion: @escaping(restaurantResponse)) {
        
        var restaurants = [Restaurant]()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        service.request(.search(lat: lat, lon: lon,
                                offset: offset,
                                sortBy: option?.search ?? "distance",
                                limit: limit)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let root = try self.jsonDecoder.decode(Root.self, from: response.data)
                    root.businesses.forEach { (business) in
                        var restaurant = Restaurant(business: business)
                        restaurant.category = option ?? .all
                        restaurants.append(restaurant)
                    }
                completion(restaurants, nil)
                }catch{
                    completion(nil, URLRequestFailureResult(rawValue: 1))
                }
            case .failure(_):
                if !NetworkMonitor.shared.isConnected {completion(nil, URLRequestFailureResult.noInternet) }
                else { completion(nil, URLRequestFailureResult.serverFailure)}
            }
        }
    }
    func fetchRestaurantsByTerm(lat: Double, lon: Double,terms:String, completion: @escaping(restaurantResponse) ){
        var restaurants = [Restaurant]()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        if !NetworkMonitor.shared.isConnected {completion(nil, URLRequestFailureResult.noInternet) }
        service.request(.searchByTerm(lat: lat, lon: lon, term: terms)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let root = try self.jsonDecoder.decode(Root.self, from: response.data)
                    root.businesses.forEach { (business) in
                        let restaurant = Restaurant(business: business)
                        restaurants.append(restaurant)
                    }
                completion(restaurants, nil)
                }catch{
                    print("DEBUG: JsonDecode error with ..\(error)")
                }
            case .failure(let error):
                completion(nil, URLRequestFailureResult.serverFailure)
            }
        }
    }
    func fetchDetail(id : String, completion: @escaping(detailResponse)){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        service.request(.detail(id:id)) {(result) in
            switch result {
            case .success(let response):
                do {
                     let detail = try self.jsonDecoder.decode(Details.self, from: response.data)
                    completion(detail, nil)
                }catch {
                    completion(nil, URLRequestFailureResult(rawValue: 0))
                    print("DEBUG: Failed to return detail \(error)")
                }
            case .failure(let error):
                print("DEBUG:\(error.localizedDescription)")
                return
            }
        }
    }

}
