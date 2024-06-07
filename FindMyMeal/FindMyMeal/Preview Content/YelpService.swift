////
////  YelpService.swift
////  MunchMadness
////
////  Created by Tanner Macpherson on 3/7/24.
////
//
//import Foundation
//
//let apiKey = "jP1JFTIs5K0_F_LOWNo4F7dGM9tk0LxL2tHw42Cv7wE-aJMmBqAmcWuAe9hMy8LMntqe17rEMTgUE7tSLZgae8_P8jzkMOJNgahnDNxLZWvj-8f9vUBNhTUBAUPqZXYx"
//
//func getRestaurants() async throws -> RestaurantList {
//    
//    let endpoint = "https://api.yelp.com/v3/businesses/search?location=Chapel Hill&radius=2000&price=1&term=pizza"
//    
//    
//    
//        guard let url = URL(string: endpoint) else {
//            throw YelpError.invalidURL
//        }
//
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//    
//    let (data, response) = try await URLSession.shared.data(for: request)
//    
//    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//        throw YelpError.invalidResponse
//    }
//    
//    do {
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return try decoder.decode(RestaurantList.self, from: data)
//    } catch {
//        throw YelpError.invalidData
//        
//    }
//}
//
