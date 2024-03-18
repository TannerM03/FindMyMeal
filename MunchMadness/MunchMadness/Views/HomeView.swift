//
//  SearchView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: String
    var body: some View {
        NavigationView {
            
            VStack {
                Text("MUNCH MADNESS")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.top, 50)
                
                Spacer()
                
                Button(action: {
                    selectedTab = "2"
                }, label: {
                    Text("Let the Madness begin!")
                })
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                )
                .padding(.bottom, 50)
                Spacer()
            }.background(
                Image("bracket")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 500, height: 300)
                    .rotationEffect(.degrees(90))
                    .padding(.top, 40))
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var tab = "1"
    
    static var previews: some View {
        HomeView(selectedTab: $tab)
    }
}
