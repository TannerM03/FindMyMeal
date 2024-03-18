//
//  ContentView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "1"
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
                .tag("1")
            FilterView()
                .tabItem {
                    Label("Filters", systemImage: "menucard.fill")
                }
                .tag("2")
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "book.fill")
                }
                .tag("3")
        }
    }
}

#Preview {
    ContentView()
}
