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
    @Published var term: String = ""
    @Published var limit: Int = 10
    @Published var price: Int = 1
    @Published var price2: Int = 2
    @Published var price3: Int = 3
    @Published var price4: Int = 4
    @Published var radius: Int = 0
    //radius: 1609 meters in a mile
    //price: 1-4

    
    @Published var restaurants: [RestaurantViewModel] = []
    
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
  
    func getPlaces(with term: String, price: Int, price2: Int, price3: Int, price4: Int, radius: Int) {

        getRestaurants(latitude: latitude, longitude: longitude, category: category, limit: limit, term: term, price: price, price2: price2, price3: price3, price4: price4, radius: radius) { (restaurants, error) in
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
