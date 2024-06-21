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
    @Binding var isNewSearch: Bool
    @Binding var topIndex: Int
    @Binding var bottomIndex: Int
    @Binding var searching: Bool
    @Binding var didSubmit: Bool
    @Binding var firstSearch: Bool
    @Binding var animationCount: Int
    
    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            FilterView(latitude: 34.149401, longitude: -77.862974, vm: RestaurantListViewModel(), locationManager: LocationManager(), selectedTab: $selectedTab, savedRestaurant: $savedRestaurant, restaurants: $restaurants, isNewSearch: $isNewSearch, topIndex: $topIndex, bottomIndex: $bottomIndex, searching: $searching, firstSearch: $firstSearch, animationCount: $animationCount)
                .tabItem {
                    Label("Filters", systemImage: "menucard.fill")
                }
                .tag("1")
            SwiperView(vm: vm, selectedTab: $selectedTab, savedRestaurant: $savedRestaurant, restaurants: $restaurants, isNewSearch: $isNewSearch, topIndex: $topIndex, bottomIndex: $bottomIndex, searching: $searching, didSubmit: $didSubmit, firstSearch: $firstSearch, animationCount: $animationCount)
            .tabItem {
                Image(systemName: "gamecontroller.fill")
                Text("Swiper")
            }
                .tag("2")
            FavoritesView(restaurant: $savedRestaurant, selectedTab: $selectedTab, didSubmit: $didSubmit)
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
