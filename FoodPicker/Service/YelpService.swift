//
//  YelpService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/3.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Moya

private let apiKey = "NDYmGcRu-jtnwWAlz4DQCujSkV40o0slbM1UvUwxAgIcN95XFI8yEtr9L6YKSn6epsJR6d30YxD5XAmHqHR_l-8-uj7anj05-j2bQYQO__a1H0_-tuDQTVrBXpeIYnYx"

private let clientID = "YuD9cka95Qb_g7WsdCA-rQ"

enum YelpService{
    enum BusinessesProvider : TargetType {
        case searchByTerm(lat:Double, lon: Double, term: String)
        case search(_ lat: Double, _ lon: Double,
                    category: String = "food",
                    sortBy : String,
                    offset: Int = 0,
                    limit: Int)
        case detail(id: String)

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
                                                       "categories": "food",
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
