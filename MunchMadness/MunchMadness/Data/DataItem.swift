//
//  DataItem.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 4/23/24.
//

import Foundation
import SwiftData

@Model
class DataItem: Identifiable{
    
    var id: String
    var name: String
    var isClosed: Bool
    var reviewCount: Int
    var imageUrl: String
    var rating: Double
    var price: String
    var address1: String
    var city: String
    var displayPhone: String
    var distance: Double
    var url: String
    
    init(id: String, name: String, isClosed: Bool, reviewCount: Int, imageUrl: String, rating: Double, price: String, address1: String, city: String, displayPhone: String, distance: Double, url: String) {
        self.id = id
        self.name = name
        self.isClosed = isClosed
        self.reviewCount = reviewCount
        self.imageUrl = imageUrl
        self.rating = rating
        self.price = price
        self.address1 = address1
        self.city = city
        self.displayPhone = displayPhone
        self.distance = distance
        self.url = url
    }
}
