//
//  InstructionsView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 5/24/24.
//

import SwiftUI

struct InstructionsView: View {
    @Binding var selectedTab: String
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Instructions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
            }
                VStack {
                    HStack {
                        Text("Filters")
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Image(systemName: selectedTab == "1" ? "menucard.fill" : "menucard")

                    }
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    Text("Select your preferred filters and search for restaurants!")
                        .multilineTextAlignment(.center)
                }

                VStack {
                    HStack {
                        Text("Swiper")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Image(systemName: selectedTab == "2" ? "gamecontroller.fill" : "gamecontroller")

                    }
                    .padding(.top, 30)
                    .padding(.leading, 10)

                    Text("Swipe left or right to discard the less preferred restaurant, go until there's only one standing!")
                        .multilineTextAlignment(.center)
                }


                VStack {
                    HStack {
                        Text("Favorites")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Image(systemName: selectedTab == "3" ? "heart.fill" : "heart")
                    }
                    .padding(.top, 30)
                    .padding(.leading, 10)

                Text("Add restaurants to favorites and keep notes for future reference!")
                    .multilineTextAlignment(.center)
                }



        }.padding(.horizontal, 30)
            .foregroundStyle(.black)
    }
}

//#Preview {
//    InstructionsView()
//}
