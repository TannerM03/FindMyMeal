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
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.uncBlue
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("MUNCH MADNESS")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding(.top, 50)
                    
                    
                    Spacer()
                    
                    BeginButton(selectedTab: $selectedTab)
                    Spacer()
                }
                
            }

            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var tab = "1"
    
    static var previews: some View {
        HomeView(selectedTab: $tab)
    }
}

struct BeginButton: View {
    @Binding var selectedTab: String
    var body: some View {
        Button(action: {
            selectedTab = "2"
        }, label: {
            Text("BEGIN")
                .font(.title2)
        })
        
        .padding()
        .foregroundColor(.black)
        .frame(width: 150, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.black, lineWidth: 1)
                )
            
        )
        .padding(.bottom, 50)
    }
}
