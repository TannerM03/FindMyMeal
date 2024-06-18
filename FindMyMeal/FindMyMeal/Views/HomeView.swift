//
//  SearchView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: String
    @StateObject var lm = LocationManager()
    @State var vm = RestaurantListViewModel()
    @State var restaurants: [RestaurantViewModel] = []
    @State private var tabViewUp: Bool = false
    @State var isNewSearch: Bool = false
    @State var firstSearch: Bool = true
    
    var body: some View {
        
        NavigationView {
            ZStack {
//                Color.uncBlue
//                    .edgesIgnoringSafeArea(.all)
                Image("HomeBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
//                    Text("FindMyMeal")
//                        .font(.largeTitle)
//                        .fontWeight(.heavy)
//                        .padding(.top, 50)
                    
                    
                    Spacer()
                    
                    BeginButton(selectedTab: $selectedTab, vm: $vm, restaurants: $restaurants, tabViewUp: $tabViewUp, isNewSearch: $isNewSearch, firstSearch: $firstSearch)
                        .offset(y: 200)

                    Spacer()
                }
                
            }

            
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    @State static var tab = "1"
//    
//    static var previews: some View {
//        HomeView(selectedTab: $tab)
//    }
//}

struct BeginButton: View {
    @Binding var selectedTab: String
    @Binding var vm: RestaurantListViewModel
    @Binding var restaurants: [RestaurantViewModel]
    @Binding var tabViewUp: Bool
    @Binding var isNewSearch: Bool
    @State var topIndex = 0
    @State var bottomIndex = 1
    @State var searching = false
    @State var didSubmit = false
    @Binding var firstSearch: Bool
    @State var animationCount = 0
    

    var body: some View {
//        NavigationStack {
        NavigationLink(destination: TabsView(selectedTab: $selectedTab, vm: vm, restaurants: $restaurants, isNewSearch: $isNewSearch, topIndex: $topIndex, bottomIndex: $bottomIndex, searching: $searching, didSubmit: $didSubmit, firstSearch: $firstSearch, animationCount: $animationCount).navigationBarBackButtonHidden(true)) {
                Text("BEGIN")
                    .font(.title2)
                    .padding()
                    .foregroundColor(Color.darkerblue)
                    .frame(width: 150, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.white)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 40)
//                                    .stroke(Color.black, lineWidth: 1)
//                            )
                        
                    )
            }
            
            
            .padding(.bottom, 50)
//        }
    }
}
