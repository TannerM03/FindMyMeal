//
//  ContentView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        if locationManager.hasLocationAccess {
            TabsView(locationManager: locationManager)
        } else {
            RequestLocationAccessView(locationManager: locationManager)
        }
    }
}

//keep using comments to figure out why it's not fetching any restaurants
//You're close!!

#Preview {
    ContentView()
}
