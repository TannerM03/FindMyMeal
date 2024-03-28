//
//  SwiperView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI


//returns 2 less than what the limit is set at
struct SwiperView: View {
    @ObservedObject var vm: RestaurantListViewModel
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            if vm.restaurants.isEmpty {
                Text("Loading restaurants...")
            } else {
                // current restaurant
                Text("\(vm.restaurants.count)")
                CardView(restaurant: vm.restaurants[currentIndex])
                    .padding()
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                // Deletes if you swipe left
                                if value.translation.width < -100 {
                                    // removes top restaurant
                                    self.removeCurrentRestaurant()
                                }
                            }
                
                    )
                
                //next restaurant if available
                if currentIndex + 1 < vm.restaurants.count {
                    CardView(restaurant: vm.restaurants[currentIndex + 1])
                        .padding()
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    // Deletes if you swipe left
                                    if value.translation.width < -100 {
                                        // removes bottom restaurant
                                        self.removeSecondRestaurant()
                                    }
                                }
                        )
                } else {
                    //make an animnation here for the winner at currentIndex
                }
            }
        }
        .onAppear {
            vm.getPlaces(with: vm.term, longitude: vm.longitude, latitude: vm.latitude, radius: vm.radius, openNow: vm.openNow, prices: vm.prices)
        }
    }
    
    // remove the current restaurant and update index
    private func removeCurrentRestaurant() {
        if currentIndex < vm.restaurants.count {
            vm.restaurants.remove(at: currentIndex)
        }
        // Reset index if it exceeds the bounds of the array
        if currentIndex >= vm.restaurants.count {
            currentIndex = 0
        }
    }
    private func removeSecondRestaurant() {
        if currentIndex < vm.restaurants.count {
            vm.restaurants.remove(at: currentIndex + 1)
        }
        // Reset index if it exceeds the bounds of the array
        if currentIndex >= vm.restaurants.count {
            currentIndex = 0
        }
    }
}


#Preview {
    SwiperView(vm: RestaurantListViewModel())
}
