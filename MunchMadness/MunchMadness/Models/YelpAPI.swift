//
//  GetRestaurants.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import Foundation
import CoreLocation

enum YelpService {
    static func getRestaurants(latitude: CLLocationDegrees, longitude: CLLocationDegrees, category: String, limit: Int, term: String, prices: [Int], radius: Int, open_now: Bool, completionHandler: @escaping ([RestaurantViewModel]?, Error?) -> Void) {
        
        let priceString = prices.map(String.init).joined(separator: ",")
        
        let baseURL = "https://api.yelp.com/v3/businesses/search"
            let parameters = [
                "latitude": "\(latitude)",
                "longitude": "\(longitude)",
                "categories": "\(category)",
                "limit": "\(limit)",
                "term": "\(term)",
                "price": priceString,
                "radius": "\(radius)",
                "open_now": "\(open_now)"
            ]
        print("base url: \(baseURL)")
        var components = URLComponents(string: baseURL)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
                completionHandler(nil, NSError(domain: "URLConstructError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL"]))
                return
            }
        print("\(url)")

        var request = URLRequest(url: url)
        request.setValue("Bearer \(Secret.yelpKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, repsonse, error) in
            if let error = error {
                        completionHandler(nil, error)
                
                        return
                    }
                    guard let data = data else {
                        completionHandler(nil, NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))

                        return
                    }

                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            completionHandler(nil, NSError(domain: "JSONError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))

                            return
                        }

                        guard let businesses = json["businesses"] as? [[String: Any]] else {
                            completionHandler(nil, NSError(domain: "BusinessesError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No businesses found"]))

                            return
                        }

                        var restaurantList: [RestaurantViewModel] = []
                
                for business in businesses {
                    if let name = business["name"] as? String,
                        let isClosed = business["is_closed"] as? Bool,
                        let reviewCount = business["review_count"] as? Int,
                        let imageUrl = business["image_url"] as? String,
                        let rating = business["rating"] as? Double,
                        let price = business["price"] as? String,
                        let location = business["location"] as? [String: Any],
                        let address1 = location["address1"] as? String,
                        let city = location["city"] as? String,
                        let displayPhone = business["display_phone"] as? String,
                        let distance = business["distance"] as? Double,
                        let url = business["url"] as? String {
                                    
                        let restaurant = RestaurantViewModel(name: name,
                                                             isClosed: isClosed,
                                                             reviewCount: reviewCount,
                                                             imageUrl: imageUrl,
                                                             rating: rating,
                                                             price: price,
                                                             address1: address1,
                                                             city: city,
                                                             displayPhone: displayPhone,
                                                             distance: distance,
                                                             url: url)
                            
                        restaurantList.append(restaurant)
                        }
                }
        
                completionHandler(restaurantList, nil)
                
            } catch {
                completionHandler(nil, error)
            }
            }.resume()
        }
}


