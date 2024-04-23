//
//  ProfileView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI
import SwiftData


struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [DataItem]
    
    @State var restaurant: RestaurantViewModel?
    
    var body: some View {
        ZStack {
            List {
                ForEach (items) { item in
                    Text(item.name)
                }.onDelete { indexes in
                    for index in indexes {
                        deleteItem(items[index])
                    }
                }
            }
            
        }.onAppear {
            addItem()
        }
    }
    func addItem() {
        if let restaurant = restaurant {
            let item = DataItem(id: restaurant.id, name: restaurant.name, isClosed: restaurant.isClosed, reviewCount: restaurant.reviewCount, imageUrl: restaurant.imageUrl, rating: restaurant.rating, price: restaurant.price, address1: restaurant.address1, city: restaurant.city, displayPhone: restaurant.displayPhone, distance: restaurant.distance, url: restaurant.url)
            if items.contains(where: {$0.id == item.id}) {
                print("already contains this resaurant")
            } else {
                print("added \(item.id)")
                context.insert(item)
            }
        }
        
        print(context)
    }
    func deleteItem(_ item: DataItem) {
        context.delete(item)
    }
}

//#Preview {
//    ProfileView(restaurant: RestaurantViewModel())
//}
