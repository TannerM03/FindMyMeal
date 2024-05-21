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
    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
                .tag("1")
            FilterView(latitude: 34.149401, longitude: -77.862974, vm: RestaurantListViewModel(), locationManager: LocationManager(), selectedTab: $selectedTab, savedRestaurant: $savedRestaurant)
                .tabItem {
                    Label("Filters", systemImage: "menucard.fill")
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
