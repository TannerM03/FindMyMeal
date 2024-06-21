//
//  SwiperView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI
import ConfettiSwiftUI


struct SwiperView: View {
    @ObservedObject var vm: RestaurantListViewModel
    
    @State private var currentIndex: Int = 0
    @State private var offset = CGSize.zero
    @State private var offsetTwo = CGSize.zero

    @State private var rotationAngle: Double = 0
        
    @State private var tab = "3"
    
    @Binding var selectedTab: String
    
    @Binding var savedRestaurant: RestaurantViewModel?
    
    @Binding var restaurants: [RestaurantViewModel]

    
    @Binding var isNewSearch: Bool
    @Binding var topIndex: Int
    @Binding var bottomIndex: Int
    @Binding var searching: Bool
    @Binding var didSubmit: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var instructionsClicked = false
    @Binding var firstSearch: Bool
    @State private var confettiCounter = 0
    @State private var finalCardOffset = CGSize(width: 0, height: 0)
    @State private var shimmerOffset: CGFloat = -UIScreen.main.bounds.width
    @Binding var animationCount: Int


    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors:[Color.uncBlue, Color.darkerblue]), startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: .bottom)
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        selectedTab = "1"
                    }label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.darkerblue)
                            .padding(.leading, 15)

                    }
                    Spacer()
                    Text("Game Time!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.darkerblue)
                    Spacer()
                    Button {
                        instructionsClicked = true
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.darkerblue)
                            .padding(.trailing, 15)
                    }
                }
                    .background(
                Rectangle()
                    .frame(width: 600, height: 122)
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                    )
                Spacer()
                if (firstSearch) {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("Choose filters to search for restaurants!")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .frame(width: 390)
                        Spacer()
                    }
                }
                else if restaurants.isEmpty && searching == true {
                    VStack {
                        Spacer()
                        Text("Loading restaurants...")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                } else if (restaurants.isEmpty && searching == false) {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("No restaurants found :(")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        Text("Try altering your search")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                else {
                    if restaurants.count == 1 {
                        VStack {
                            Spacer()
                            CardView(restaurant: restaurants[0])
                                .rotationEffect(.degrees(rotationAngle))
                                .offset(finalCardOffset)
                                .onAppear {
                                    if (animationCount < 1) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            finalCardOffset = .zero
                                            rotationAngle += 720
                                        }
                                    }

                                }
                            Button {
                                savedRestaurant = restaurants[0]
                                selectedTab = "3"
                                didSubmit = true
                            }label: {
                                Text("Click to add to favorites")
                                    .padding()
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                            .shadow(radius: 2)
                                    )
                            }.confettiCannon(counter: $confettiCounter, num: 200,  rainHeight: 900, radius: 370)

                            .padding(.top, 40)
                            
                            Spacer()
                        }
                        .onAppear {
                            confettiCounter = confettiCounter + 1
                        }
                    }
                    
                    else {
                        Text("Swipe to Eliminate!")
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
                                        // Deletes if you swipe
                                        SwipeCard(width: offset.width)
                                    }
                                
                            )
                            .onAppear {
                                shimmerOffset = -UIScreen.main.bounds.width
                            }
                        if restaurants.count != 1 {
                            Text("VS")
                                .font(.title)
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
                                            // Deletes if you swipe

                                            SwipeSecondCard(width: offsetTwo.width)
                                        }
                                    
                                )
                            Text("Restaurants Remaining: \(restaurants.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 8)
                            Spacer()
                        }
                    }
                }
            }.overlay {
                if (instructionsClicked) {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            instructionsClicked = false
                        }
                    InstructionsView(selectedTab: $selectedTab)
                        .padding(6)
                        .multilineTextAlignment(.leading)
                        .frame(width: 350, height: 435, alignment: .topLeading)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                                .fill(Color.white)
                        }.overlay(alignment: .topTrailing) {
                            Button {
                                instructionsClicked = false
                            }label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .foregroundStyle(.black)
                                    .frame(width: 25, height: 25)
                                    .padding(.top, 10)
                                    .padding(.trailing, 10)
                            }.padding(.trailing, 15)
                                .padding(.top, 10)
                        }
                }
            }
        }.onChange(of: vm.restaurants, initial: true) { oldRestaurants, newRestaurants in
            // Update restaurants when vm.restaurants changes
            if !newRestaurants.isEmpty {
                restaurants = newRestaurants
            }
        }.onAppear{
            if restaurants.count == 1 {
                animationCount = animationCount + 1
            }
        }

    }
    
    private func setRestaurant() {
        restaurants = [restaurants[0]]
    }
    
    private func SwipeCard(width: CGFloat) {
        finalCardOffset = CGSize(width: 0, height: 185)
        isNewSearch = false
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
        finalCardOffset = CGSize(width: 0, height: -98)
        isNewSearch = false
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

