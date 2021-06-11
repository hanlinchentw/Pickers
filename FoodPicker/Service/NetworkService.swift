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
    case internetFailure
    case clientFailure
}

class  NetworkService {
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    static let shared = NetworkService()
    func fetchRestaurants(lat: Double, lon: Double, withOffset offset: Int = 0, category: String = "food", option: recommendOption? = nil, limit: Int, completion: @escaping(restaurantResponse)) {
        
        var restaurants = [Restaurant]()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        service.request(.search(lat: lat, lon: lon,
                                offset: offset,
                                category: category,
                                sortBy: option?.search ?? "distance",
                                limit: limit)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let root = try self.jsonDecoder.decode(Root.self, from: response.data)
                    root.businesses.forEach { (business) in
                        var restaurant = Restaurant(business: business)
                        restaurant.division = option?.description ?? "All restaurants"
                        restaurants.append(restaurant)
                    }
                completion(restaurants, nil)
                }catch{
                    completion(nil, URLRequestFailureResult(rawValue: 1))
                }
            case .failure(let error):
                completion(nil, URLRequestFailureResult(rawValue: 0))
                print("DEBUG:\(error.localizedDescription)")
            }
        }
    }
    func fetchRestaurantsByTerm(lat: Double, lon: Double,terms:String, completion: @escaping([Restaurant]?)->Void){
        var restaurants = [Restaurant]()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        service.request(.searchByTerm(lat: lat, lon: lon, term: terms)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let root = try self.jsonDecoder.decode(Root.self, from: response.data)
                    root.businesses.forEach { (business) in
                        let restaurant = Restaurant(business: business)
                        restaurants.append(restaurant)
                    }
                completion(restaurants)
                }catch{
                    print("DEBUG: JsonDecode error with ..\(error)")
                }
            case .failure(let error):
                print("DEBUG:\(error.localizedDescription)")
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
