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
  
    func getPlaces(with term: String, longitude: CLLocationDegrees, latitude: CLLocationDegrees, radius: Int, openNow: Bool, prices: [Int]) async -> [RestaurantViewModel] {
        DispatchQueue.main.async {
            self.term = term
            self.longitude = longitude
            self.latitude = latitude
            self.radius = radius
            self.openNow = openNow
            self.prices = prices
            self.isLoading = true
        }

        do {
            let fetchedRestaurants = try await YelpService.getRestaurants(latitude: latitude, longitude: longitude, category: category, limit: limit, term: term, prices: prices, radius: radius, open_now: openNow)
            DispatchQueue.main.async {
                self.restaurants = fetchedRestaurants
                self.isLoading = false
                print("getRestaurants --> Latitude: \(latitude) Longitude: \(longitude) category: \(self.category) limit: \(self.limit) term: \(term) price: \(prices) radius: \(radius) isOpen: \(openNow)")
                print("Fetched \(fetchedRestaurants.count) restaurants")
            }
            return fetchedRestaurants
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Error fetching restaurants: \(error)")
            }
            return []
        }
    }
}

