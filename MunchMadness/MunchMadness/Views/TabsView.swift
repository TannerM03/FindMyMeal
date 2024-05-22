//
//  TabsView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/21/24.
//

import SwiftUI
import CoreLocation

struct TabsView: View {
    @Binding var selectedTab: String
    @State var savedRestaurant: RestaurantViewModel?
    @ObservedObject var vm: RestaurantListViewModel
    @Binding var restaurants: [RestaurantViewModel]
    
    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            FilterView(latitude: 34.149401, longitude: -77.862974, vm: RestaurantListViewModel(), locationManager: LocationManager(), selectedTab: $selectedTab, savedRestaurant: $savedRestaurant, restaurants: $restaurants)
                .tabItem {
                    Label("Filters", systemImage: "menucard.fill")
                }
                .tag("1")
            SwiperView(vm: vm, selectedTab: $selectedTab, savedRestaurant: $savedRestaurant, restaurants: $restaurants)
            .tabItem {
                Image(systemName: "gamecontroller.fill")
                Text("Swiper")
            }
                .tag("2")
            FavoritesView(restaurant: $savedRestaurant, selectedTab: $selectedTab)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag("3")
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }.tint(.darkerblue)
    }
}

//#Preview {
//    TabsView(locationManager: LocationManager())
//}
