//
//  GetRestaurants.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import Foundation
    
func getRestaurants(latitude: Double, longitude: Double, category: String, limit: Int, term: String, price: Int, price2: Int, price3: Int, price4: Int, radius: Int,
                    completionHandler: @escaping ([RestaurantViewModel]?, Error?) -> Void) {
    
    
    let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&category=\(category)&limit=\(limit)&term=\(term)&price=\(price)&price=\(price2)&price=\(price3)&price=\(price4)&radius=\(radius)"
    
    let endpoint = URL(string: baseURL)
    
    var request = URLRequest(url: endpoint!)
    request.setValue("Bearer \(yelpKey)", forHTTPHeaderField: "Authorization")
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
                    let distance = business["distance"] as? Double {
                                
                    let restaurant = RestaurantViewModel(name: name,
                                                         isClosed: isClosed,
                                                         reviewCount: reviewCount,
                                                         imageUrl: imageUrl,
                                                         rating: rating,
                                                         price: price,
                                                         address1: address1,
                                                         city: city,
                                                         displayPhone: displayPhone,
                                                         distance: distance)
                        
                    restaurantList.append(restaurant)
                    }
            }
    
            completionHandler(restaurantList, nil)
            
        } catch {
            completionHandler(nil, error)
        }
        }.resume()
    }

