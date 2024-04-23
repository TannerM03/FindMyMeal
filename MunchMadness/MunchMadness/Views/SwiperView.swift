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
    @State private var offset = CGSize.zero
    @State private var offsetTwo = CGSize.zero
    @State private var topIndex = 0
    @State private var bottomIndex = 1
    @State private var rotationAngle: Double = 0
    
    @State private var restaurants: [RestaurantViewModel] = []
    

    
    var body: some View {
        ZStack {
            Color.uncBlue
            VStack {
                Text("Game Time!")
                    .padding(.top, -40)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.darkerblue)
                    .italic()
                    .background(
                Rectangle()
                    .frame(width: 400, height: 35)
                    .foregroundColor(.white)
            )
                Spacer()
                if restaurants.isEmpty {
                    Text("Loading restaurants...")
                } else if restaurants.count == 1 {
                    CardView(restaurant: restaurants[0])
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.easeInOut(duration: 1.0))
                        .onAppear {
                                        // Start the animation when the view appears
                            withAnimation {
                                rotationAngle += 720 // Rotate one full circle
                            }
                        }
                    NavigationLink {
                        ProfileView(restaurant: restaurants[0])
                    }label: {
                        Text("Add to favorites?")
                    }

                    Spacer()
                }
                else {
                    // current restaurant
                    Text("Restaurants Remaining: \(restaurants.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color:.gray, radius: 5)

                    CardView(restaurant: restaurants[topIndex])
                        .padding()
                        .offset(x: offset.width, y: offset.height * 0.4)
                        .rotationEffect(.degrees(Double(offset.width / 80)))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    offset = gesture.translation
                                }
                                .onEnded { value in
                                    // Deletes if you swipe left
//                                    if value.translation.width < -100 || value.translation.width > 100{
//                                        // removes top restaurant
//                                        self.removeCurrentRestaurant()
//                                    }
                                    SwipeCard(width: offset.width)
                                }
                            
                        )
                    if restaurants.count != 1 {
                        Text("VS")
                            .font(.title)
                            .italic()
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color:.gray, radius: 5)
                    }
                    
                    //next restaurant if available
                    if bottomIndex < restaurants.count && bottomIndex != topIndex {
                        CardView(restaurant: restaurants[bottomIndex])
                            .padding()
                            .offset(x: offsetTwo.width, y: offsetTwo.height * 0.4)
                            .rotationEffect(.degrees(Double(offsetTwo.width / 80)))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        offsetTwo = gesture.translation
                                    }
                                    .onEnded { value in
                                        // Deletes if you swipe left
//                                        if value.translation.width < -100 || value.translation.width > 100 {
//                                            // removes top restaurant
//                                            self.removeSecondRestaurant()
//                                        }
                                        SwipeSecondCard(width: offsetTwo.width)
                                    }
                                
                            )
                        Spacer()
                    }
                }
            }
        }.onChange(of: vm.restaurants, initial: true) { oldRestaurants, newRestaurants in
            // Update restaurants when vm.restaurants changes
            if !newRestaurants.isEmpty {
                restaurants = newRestaurants
            }
        }

    }
    
    private func SwipeCard(width: CGFloat) {
        withAnimation(.easeInOut(duration: 0.2)) {
            switch width {
            case -500...(-120):
                offset = CGSize(width: -500, height: 0)
                removeCurrentRestaurant()
            case 120...(500):
                offset = CGSize(width: 500, height: 0)
                removeCurrentRestaurant()
            default:
                offset = .zero
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            offset = .zero
        }
        
    }
    private func SwipeSecondCard(width: CGFloat) {
        withAnimation(.easeInOut(duration: 0.2)) {
            switch width {
            case -500...(-120):
                offsetTwo = CGSize(width: -500, height: 0)
                removeSecondRestaurant()
            case 120...(500):
                offsetTwo = CGSize(width: 500, height: 0)
                removeSecondRestaurant()
            default:
                offsetTwo = .zero
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            offsetTwo = .zero
        }
    }
    
    // remove the current restaurant and update index
    private func removeCurrentRestaurant() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if topIndex < restaurants.count {
                restaurants.remove(at: topIndex)
                if topIndex < bottomIndex {
                    bottomIndex = 0
                    topIndex = bottomIndex + 1
                }
            }
            // Reset index if it exceeds the bounds of the array
            if topIndex >= restaurants.count {
                topIndex = 0
            }
        }
    }
    private func removeSecondRestaurant() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if bottomIndex < restaurants.count {
                restaurants.remove(at: bottomIndex)
                if bottomIndex < topIndex {
                    topIndex = 0
                    bottomIndex = topIndex + 1
                }
                
            }
            // Reset index if it exceeds the bounds of the array
            if bottomIndex >= restaurants.count {
                bottomIndex = 0
            }
        }
    }

}


#Preview {
    SwiperView(vm: RestaurantListViewModel())
}
