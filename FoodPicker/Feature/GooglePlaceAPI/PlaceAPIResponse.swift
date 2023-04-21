//
//  Place.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation

struct PlaceApiResponse: Decodable {
	var nextPageToken: String
	var results: Array<PlaceApiResult>
}

struct PlaceApiResult: Decodable {
	var businessStatus: String
	
}

//{
//	"html_attributions": [],
//	"next_page_token": "Aap_uEAHsgFErpxZrytW1mgKsefD327VCf0OgNF9vpXPwTOG6AGhEZpGgMgofSzgCahevXhneCe9M9H24SOuE4ZcaE0ZR01gVykQZ6EoDnlWEQvXBXe6z0sgF5MQo7qBb6uD4VHKDLhgR59Lb86BzTHJzTzbm61OAPvyInZoaQxK8-oEf2PShZT7XRJKoF5nISbwvU_-RomwGDVi27oj0fToIyV-Vj2ftJw8ZUPbdGGCbcDolQyAwj11Dy2aaeK4SGwg2mO5Akxa7fCze2RJ0GCAvXXp7omTFDy_47OXsFgDPfzluc7mEb5VlzlIMZ0eWQ8VeNigtv-XZZG0f3HSo81Yeq3QhXedJ5oNE1XCwyMly3YVgw_h3amOzAOuDigF1pgFnfGyzxD8vr2bfbPTNvA9l7IJ8Q",
//	"results":
//		[
//			{
//				"business_status": "OPERATIONAL",
//				"formatted_address": "1 Macquarie St, Sydney NSW 2000, Australia",
//				"geometry":
//					{
//						"location": { "lat": -33.8592041, "lng": 151.2132635 },
//						"viewport":
//							{
//								"northeast":
//									{ "lat": -33.85786707010728, "lng": 151.2147093298927 },
//								"southwest":
//									{ "lat": -33.86056672989272, "lng": 151.2120096701072 },
//							},
//					},
//				"icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
//				"icon_background_color": "#FF9E67",
//				"icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet",
//				"name": "Aria Restaurant Sydney",
//				"opening_hours": { "open_now": false },
//				"photos":
//					[
//						{
//							"height": 4032,
//							"html_attributions":
//								[
//									'<a href="https://maps.google.com/maps/contrib/112033760018394328606">Dohyun Kim</a>',
//								],
//							"photo_reference": "Aap_uED7B83PoQ1wNgzYcFZEOw1P2DqNjlaqiXxo-r4F_NaR27uV2OiIvijkI6RYyfiiHYo9UqjnZkRtZaNTk4C6Ickh3k3stsSvBU0KfLtFow-oRujSYYChYwiYhVyP27omLzQQjafhJ2N3LJbjcMxSePKXsQzYCqmOLWg0E9mSExMJ4aM",
//							"width": 3024,
//						},
//					],
//				"place_id": "ChIJdxxU1WeuEmsR11c4fswX-Io",
//				"plus_code":
//					{
//						"compound_code": "46R7+88 Sydney, New South Wales, Australia",
//						"global_code": "4RRH46R7+88",
//					},
//				"price_level": 4,
//				"rating": 4.5,
//				"reference": "ChIJdxxU1WeuEmsR11c4fswX-Io",
//				"types": ["restaurant", "point_of_interest", "food", "establishment"],
//				"user_ratings_total": 1681,
//			},
//
