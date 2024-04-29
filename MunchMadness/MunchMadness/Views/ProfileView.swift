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
    
    @Binding var restaurant: RestaurantViewModel?
    
    
    @State private var isSheetShowing: Bool = false
    
    @State private var selectedItem: DataItem?
    
    @Binding var selectedTab: String
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundStyle(.darkerblue)
                List() {
                    ForEach (items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Text("\(item.city), \(item.state ?? "")")
                                    .font(.footnote)
                            }
                            Spacer()
                            ImageView(urlString: item.imageUrl)
                                .frame(width: 50, height: 36)
                                .cornerRadius(5)
                                .padding(.trailing, 10)
                        }.onTapGesture {
                            selectedItem = item
                        }.sheet(item: $selectedItem) { selectedItem in
                            VStack {
                                Text(selectedItem.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("\(selectedItem.city), \(selectedItem.state ?? "")")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text(selectedItem.price)
                                    .font(.callout)
                                    .fontWeight(.medium)
                                ImageView(urlString: selectedItem.imageUrl)
                                    .frame(width: 200, height: 175)
                                    .cornerRadius(5)
                                    .padding(.trailing, 10)
                            }
                        }
                        
                        
                    }.onDelete { indexes in
                        for index in indexes {
                            deleteItem(items[index])
                        }
                    }
                }.scrollContentBackground(.hidden)
                    .background(Color.uncBlue)
                    .padding(.top, -7)
            }
            
        }.onAppear {
            addItem()
        }
    }
    func addItem() {
        if let restaurant = restaurant {
            print("\(restaurant.state)")
            let item = DataItem(id: restaurant.id, name: restaurant.name, isClosed: restaurant.isClosed, reviewCount: restaurant.reviewCount, imageUrl: restaurant.imageUrl, rating: restaurant.rating, price: restaurant.price, address1: restaurant.address1, city: restaurant.city, state: restaurant.state ?? "", displayPhone: restaurant.displayPhone, distance: restaurant.distance, url: restaurant.url)
                
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
//    ProfileView(restaurant: RestaurantViewModel.example)
//}
