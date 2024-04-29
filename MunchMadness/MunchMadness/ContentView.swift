//
//  ContentView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var tab = "1"
    
    var body: some View {
        if locationManager.hasLocationAccess {
            TabsView(selectedTab: $tab)
        } else {
            RequestLocationAccessView(locationManager: locationManager)
        }
    }
}


#Preview {
    ContentView()
}
