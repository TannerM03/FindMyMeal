//
//  BusinessCardModel.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/7/24.
//


import Foundation

struct RestaurantViewModel: Codable {
    
    var name: String?
    var isClosed: Bool?
    var reviewCount: Int?
    var imageUrl: String?
    var rating: Double?
    var price: String?
    var address1: String?
    var city: String?
    var displayPhone: String?
    var distance: Double?
    
}


