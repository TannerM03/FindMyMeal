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
                            ZStack {
                                Color.uncBlue.ignoresSafeArea()
                                VStack {
//                                    Text(selectedItem.isClosed ? "Closed" : "Open")
//                                        .fontWeight(.semibold)
//                                        .foregroundColor(selectedItem.isClosed ? Color.red : Color.green)
                                    Text(selectedItem.name)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 10)
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.white)
                                        }.overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.darkerblue, lineWidth: 3)
                                        )
                                        .padding(.top, 30)
                                        .padding(.bottom, 15)

                                    HStack {
                                        // directions button
                                        Button {
                                            UIApplication.shared.open(URL(string: "http://maps.apple.com/?address=\(String(describing: selectedItem.address1))+\(selectedItem.city)")!)
                                            
                                        } label: {
                                            Text("    Directions")
                                                .frame(width: 110, height: 25)
                                                .background(Color.darkerblue)
                                                .foregroundStyle(.white)
                                                .cornerRadius(20)
                                                .font(.subheadline)
                                                .overlay(
                                                    Circle()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.black)
                                                        .padding(.trailing, 85)
                                                )
                                                .overlay(
                                                    Circle()
                                                        .frame(width: 22, height: 22)
                                                        .padding(.trailing, 85)
                                                        .foregroundStyle(.white)
                                                    
                                                        .overlay(
                                                            Image(systemName: "mappin")
                                                                .foregroundStyle(Color.darkerblue)
                                                                .fontWeight(.semibold)
                                                                .font(.footnote)
                                                                .padding(.trailing, 85)
                                                                .foregroundStyle(.black)
                                                        )
                                                )
                                            
                                            
                                        }
                                        //see more button
                                        Button {
                                            UIApplication.shared.open(URL(string: selectedItem.url)!)
                                        }label: {
                                            Text("    See More")
                                                .frame(width: 110, height: 25)
                                                .background(Color.yelpRed)
                                                .foregroundStyle(.white)
                                                .cornerRadius(20)
                                                .font(.subheadline)
                                                .overlay(
                                                    Circle()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.black)
                                                        .padding(.trailing, 85)
                                                )
                                                .overlay(
                                                    Circle()
                                                        .frame(width: 22, height: 22)
                                                        .padding(.trailing, 85)
                                                        .foregroundStyle(.white)
                                                    
                                                        .overlay(
                                                            Image(systemName: "chevron.forward.2")
                                                                .foregroundStyle(Color.yelpRed)
                                                                .fontWeight(.semibold)
                                                                .font(.footnote)
                                                                .padding(.trailing, 85)
                                                                .foregroundStyle(.black)
                                                        )
                                                )
                                        }
                                    }.padding(.bottom, 15)
                                    ImageView(urlString: selectedItem.imageUrl)
                                        .frame(width: 275, height: 242)
                                        .cornerRadius(5)
                                        .multilineTextAlignment(.center)
                                        .padding(4)
                                        .background(Color.white)
                                        .shadow(radius: 5)
                                        .padding(.bottom, 10)

                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                        Text(String(format: "%.1f", item.rating))
                                            .fontWeight(.semibold)
                                        Text("(\(item.reviewCount)) on Yelp")
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("*")
                                        Text("\(item.price)")

                                    }.font(.subheadline)
                                        .padding(10)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.white)
                                        }.padding(.bottom, 5)
                                    
                                Text("\(selectedItem.city), \(selectedItem.state ?? "")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white)
                                    }.padding(.bottom, 15)
               
                                    Text("My Notes")
                                        .font(.title3)
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                        .frame(width: 300, height: 75)
                                    Spacer()
                                }.padding(.horizontal, 20)
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
//    ProfileView(restaurant: RestaurantViewModel.example, selectedTab: $selectedTab)
//}
