//
//  RestaurantListViewModel.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import Foundation

class RestaurantListViewModel: ObservableObject {
    @Published var latitude: Double = 35.920165
    @Published var longitude: Double = -79.053702
    @Published var category: String = "restaurant"
    @Published var term: String = "wings"
    @Published var limit: Int = 5 + 2
    //radius: 1609 meters in a mile
    //price: 1-4

    
    @Published var restaurants: [RestaurantViewModel] = []
    
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
  
    func getPlaces() {

        getRestaurants(latitude: latitude, longitude: longitude, category: category, limit: limit, term: term) { (restaurants, error) in
            if let error = error {
                print("Error fetching restaurants: \(error)")
            } else if let restaurants = restaurants {
                DispatchQueue.main.async {
                    self.restaurants = restaurants
                    print("Fetched \(restaurants.count) restaurants")
                }
            }
        }
            
            
        
    }
}
