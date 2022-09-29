//
//  Nearby.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

struct Base: Decodable {
	let results: Array<Nearyby>
}

struct Nearyby: Decodable {
	let id: String
	let name: String
	let price: Double?
	let rating: Double?
	let reviewCount: Int?
	var types: Array<String> = []
	var photos: Array<PlacePhoto> = []
	let geometry: Geometry?
	
}

extension Nearyby {
	enum CodingKeys: String, CodingKey {
		case id = "place_id"
		case price = "price_level"
		case name
		case rating
		case types
		case photos
		case geometry
		case reviewCount = "user_ratings_total"
	}
}

struct Geometry: Decodable {
	let location: Location
}

struct Location: Decodable {
	let lat: Double
	let lng: Double
}

struct PlacePhoto: Decodable {
	let photoReference: String
	
	enum CodingKeys: String, CodingKey {
		case photoReference = "photo_reference"
	}
}


/*
 {
	 "html_attributions": [],
	 "results":
		 [
			 {
				 "business_status": "OPERATIONAL",
				 "geometry":
					 {
						 "location": { "lat": -33.8587323, "lng": 151.2100055 },
						 "viewport":
							 {
								 "northeast":
									 { "lat": -33.85739847010727, "lng": 151.2112436298927 },
								 "southwest":
									 { "lat": -33.86009812989271, "lng": 151.2085439701072 },
							 },
					 },
				 "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/bar-71.png",
				 "icon_background_color": "#FF9E67",
				 "icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/bar_pinlet",
				 "name": "Cruise Bar",
				 "opening_hours": { "open_now": false },
				 "photos":
					 [
						 {
							 "height": 608,
							 "html_attributions":
								 [
									 '<a href="https://maps.google.com/maps/contrib/112582655193348962755">A Google User</a>',
								 ],
							 "photo_reference": "Aap_uECvJIZuXT-uLDYm4DPbrV7gXVPeplbTWUgcOJ6rnfc4bUYCEAwPU_AmXGIaj0PDhWPbmrjQC8hhuXRJQjnA1-iREGEn7I0ZneHg5OP1mDT7lYVpa1hUPoz7cn8iCGBN9MynjOPSUe-UooRrFw2XEXOLgRJ-uKr6tGQUp77CWVocpcoG",
							 "width": 1080,
						 },
					 ],
				 "place_id": "ChIJi6C1MxquEmsR9-c-3O48ykI",
				 "plus_code":
					 {
						 "compound_code": "46R6+G2 The Rocks, New South Wales",
						 "global_code": "4RRH46R6+G2",
					 },
				 "price_level": 2,
				 "rating": 4,
				 "reference": "ChIJi6C1MxquEmsR9-c-3O48ykI",
				 "scope": "GOOGLE",
				 "types":
					 ["bar", "restaurant", "food", "point_of_interest", "establishment"],
				 "user_ratings_total": 1269,
				 "vicinity": "Level 1, 2 and 3, Overseas Passenger Terminal, Circular Quay W, The Rocks",
			 },
			],
	 "status": "OK",
 }
 */
