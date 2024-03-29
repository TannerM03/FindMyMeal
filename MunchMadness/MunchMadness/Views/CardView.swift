//
//  CardView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI

struct CardView: View {
    let restaurant: RestaurantViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(spacing: 8) {
                Text(restaurant.name ?? "")
                    .font(.title)
                    .multilineTextAlignment(.center)
                HStack {
                    if let rating = restaurant.rating {
                        Text(String(format: "%.1f", rating))
                            .fontWeight(.bold)
                    }
                    Text("(\(restaurant.reviewCount ?? 0)) on Yelp")
                        .foregroundColor(.secondary)
                }
                Text("\(restaurant.address1 ?? ""), \(restaurant.city ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    if let phoneNumber = restaurant.displayPhone {
                        Text("\(phoneNumber)")
                    }
                    Text("*")
                    if let price = restaurant.price {
                        Text("\(price)")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(width: 275, height: 200)
            )
            .padding()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(restaurant: RestaurantViewModel.example)
    }
}

