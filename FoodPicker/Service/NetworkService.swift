//
//  NetworkService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/14.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Moya

private let apiKey = "EkoMg_mY0_BwpaUO3qgNECPvepWDa4_kozc_3nguycgSz3UH_Fvg7GaSIDgQAefiKI2Ep-i4JsY3_GNGeJO61F3MpuIW_D9zx8zFxP8tt7jsAEaxxk02HhV_kFENX3Yx"

private let clientID = "YuD9cka95Qb_g7WsdCA-rQ"

enum YelpService{
    enum BusinessesProvider : TargetType {
        case search(lat: Double, lon: Double, offset: Int = 0, category: String = "food", sortBy : String)
        case detail(id:String)
        
        var baseURL: URL { return URL(string:"https://api.yelp.com/v3/businesses")! }
        
        var path: String {
            switch self {
            case .search: return "/search"
            case let .detail(id): return "/\(id)"
            }
        }
        var method: Moya.Method { return .get }
        
        var sampleData: Data { return Data() }
        
        var task: Task {
            switch self {
            case let .search(lat,lon,offset, category, sortBy):
                return .requestParameters(parameters: ["categories":category,
                                                       "latitude":lat, "longitude": lon,
                                                       "limit":6,
                                                       "offset":offset,
                                                       "radius": 2000,
                                                       "sort_by":sortBy,
                                                       "locale":"zh_TW"],
                                          encoding:URLEncoding.queryString )
            case .detail :
                return .requestPlain
            }
        }
        var headers: [String : String]? { return ["Authorization":"Bearer \(apiKey)"]}
    }
}
struct  NetworkService {
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    static let shared = NetworkService()
    
    func fetchRestaurant(lat: Double, lon: Double, withOffset offset:Int,category: String, sortBy : String, option: FilterOptions, completion: @escaping([Restaurant])->Void){
        var restaurants = [Restaurant]()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        service.request(.search(lat: lat, lon: lon, offset:offset, category: category, sortBy : sortBy)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let root = try self.jsonDecoder.decode(Root.self, from: response.data)
                    root.businesses.forEach { (business) in
                        var restaurant = Restaurant(business: business)
                        restaurant.filterOption = option
                        restaurants.append(restaurant)
                    }
                }catch{
                    print("DEBUG: JsonDecode error with ..\(error.localizedDescription)")
                }
                completion(restaurants)
            case .failure(let error):
                print("DEBUG:\(error.localizedDescription)")
            }
        }
    }
    func fetchDetail(id : String, completion: @escaping(Details?)->Void){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        service.request(.detail(id:id)) {(result) in
            switch result {
            case .success(let response):
                let detail = try? self.jsonDecoder.decode(Details.self, from: response.data)
                completion(detail)
            case .failure(let error):
                print("DEBUG:\(error.localizedDescription)")
                return
            }
        }
    }
}
