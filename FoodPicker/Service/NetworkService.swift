//
//  NetworkService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/14.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Moya

private let apiKey = """
mzNNky9rzZY1Z1Yg5qHpuHO7Ck-7Tui_lJyOKcBBPidownX
h8vEZ4pQ2-xonen-jJn2onateIVBQgNYjCDzzaYI-nXYcODr6
dayDgKzJtcByX_rK9K3NCWy8_7qzX3Yx
"""

private let clientID = "YuD9cka95Qb_g7WsdCA-rQ"

enum YelpService{
    enum BusinessesProvider : TargetType {
        case searchByTerm(lat:Double, lon: Double, term: String)
        case search(lat: Double, lon: Double,
            offset: Int = 0,
            category: String = "food", sortBy : String,
            limit: Int)
        case detail(id:String)
        
        var baseURL: URL { return URL(string:"https://api.yelp.com/v3/businesses")! }
        
        var path: String {
            switch self {
            case .searchByTerm: return "/search"
            case .search: return "/search"
            case let .detail(id): return "/\(id)"
            }
        }
        var method: Moya.Method { return .get }
        
        var sampleData: Data { return Data() }
        
        var task: Task {
            switch self {
            case let .search(lat,lon,offset, category, sortBy, limit):
                return .requestParameters(parameters: ["categories": category,
                                                       "latitude":lat, "longitude": lon,
                                                       "limit":limit,
                                                       "offset": offset,
                                                       "radius": 3000,
                                                       "sort_by": sortBy,
                                                       "locale":"zh_TW"],
                                          encoding:URLEncoding.queryString )
            case let .searchByTerm(lat, lon, term):
                return .requestParameters(parameters: ["latitude":lat, "longitude": lon,
                                                       "sort_by": "distance",
                                                       "limit" : 50,
                                                       "term": term,
                                                       "locale":"zh_TW"],
                                          encoding: URLEncoding.queryString)
            case .detail :
                return .requestParameters(parameters: ["locale":"zh_TW"], encoding: URLEncoding.queryString)
            }
        }
        var headers: [String : String]? { return ["Authorization":"Bearer \(apiKey)"]}
    }
}
class  NetworkService {
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    static let shared = NetworkService()
    func fetchRestaurants(lat: Double, lon: Double, withOffset offset: Int = 0,
                         category: String = "food", option: recommendOption? = nil, limit: Int,
                         completion: @escaping([Restaurant]?)->Void){
        
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
                completion(restaurants)
                }catch{
                    print("DEBUG: JsonDecode error with ..\(error)")
                }
            case .failure(let error):
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
    func fetchDetail(id : String, completion: @escaping(Details)->Void){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        service.request(.detail(id:id)) {(result) in
            switch result {
            case .success(let response):
                do {
                     let detail = try self.jsonDecoder.decode(Details.self, from: response.data)
                    completion(detail)
                }catch {
                    print("DEBUG: Failed to return detail \(error)")
                }
            case .failure(let error):
                print("DEBUG:\(error.localizedDescription)")
                return
            }
        }
    }
}
