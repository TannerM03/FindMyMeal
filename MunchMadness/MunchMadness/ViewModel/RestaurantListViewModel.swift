//
//  RestaurantListViewModel.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import Foundation
import CoreLocation
import SwiftUI

class RestaurantListViewModel: ObservableObject {
    @Published var latitude: CLLocationDegrees = 0.0
    @Published var longitude: CLLocationDegrees = 0.0
    @Published var category: String = "restaurant"
    @Published var term: String = ""
    @Published var limit: Int = 10
    @Published var prices: [Int] = []
    @Published var radius: Int = 0
    @Published var openNow: Bool = false
    
    @Published var priceArray: [Int] = [1,2]
    @Published var attributes: String = "restaurants_delivery"


    
    @Published var restaurants: [RestaurantViewModel] = []
    
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
  
    func getPlaces(with term: String, longitude: CLLocationDegrees, latitude: CLLocationDegrees, radius: Int, openNow: Bool, prices: [Int]) {
        self.term = term
        self.longitude = longitude
        self.latitude = latitude
        self.radius = radius
        self.openNow = openNow
        self.prices = prices
        

        YelpService.getRestaurants(latitude: latitude, longitude: longitude, category: category, limit: limit, term: term, prices: prices, radius: radius, open_now: openNow ) { (restaurants, error) in
            if let error = error {
                print("price array: \(prices)")
                print("Error fetching restaurants: \(error)")
            } else if let restaurants = restaurants {
                DispatchQueue.main.async {
                    self.restaurants = restaurants
                    print("getRestaurants --> Latitude: \(latitude)Longitude: \(longitude)category: \(self.category)limit: \(self.limit)term: \(term)price: \(prices)radius: \(radius) isOpen: \(openNow)")
                    print("Fetched \(restaurants.count) restaurants")
                }
            }
        }
            
            
        
    }
}
