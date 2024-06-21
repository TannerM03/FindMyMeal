//
//  ContentView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var selectedTab = "1"
    @StateObject var vm = RestaurantListViewModel()
    
    var body: some View {
        if locationManager.hasLocationAccess {
            HomeView(selectedTab: $selectedTab)
//            TabsView(selectedTab: $tab, vm: vm, restaurants: $restaurants)
        } else {
            RequestLocationAccessView(locationManager: locationManager)
        }
    }
}


//#Preview {
//    ContentView()
//}
