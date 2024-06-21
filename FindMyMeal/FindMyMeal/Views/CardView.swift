//
//  CardView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI

struct CardView: View {
    let restaurant: RestaurantViewModel
    @State private var offset = CGSize.zero
    @State private var confirmDirections = false
    @State private var confirmYelp = false

    
    
    var body: some View {
        VStack(alignment: .leading){
            VStack() {
                    Text(restaurant.name)
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .frame(width: 265)
                        .padding(.bottom, -2)
                        HStack {
                            Image(getStarImage(rating: restaurant.rating))
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", restaurant.rating))
                                .fontWeight(.medium)
                            Text("(\(restaurant.reviewCount)) on ")
                                .foregroundStyle(.black)
                                .font(.subheadline)
                                .padding(.leading, -2)
                            Image("yelp_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 20)
                                .padding(.leading, -6)
                        }.foregroundStyle(.black)

                    
                
                HStack {
                    VStack(alignment: .center) {
                        Button {
                            confirmDirections = true
                            
                        } label: {
                            Text("    Directions")
                                .frame(width: 110, height: 25)
                                .background(Color.darkerblue)
                                .foregroundStyle(.white)
                                .cornerRadius(20)
                                .font(.subheadline)
                                .overlay(
                                    Circle()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(.black)
                                        .padding(.trailing, 85)
                                )
                                .overlay(
                                    Circle()
                                        .frame(width: 22, height: 22)
                                        .padding(.trailing, 85)
                                        .foregroundStyle(.white)
                                        
                                        .overlay(
                                            Image(systemName: "mappin")
                                                .foregroundStyle(Color.darkerblue)
                                                .fontWeight(.semibold)
                                                .font(.footnote)
                                                .padding(.trailing, 85)
                                                .foregroundStyle(.black)
                                        )
                                )
                        }
                        .foregroundStyle(.black)
                        .alert("Open Apple Maps?", isPresented: $confirmDirections) {
                            Button("Cancel") { }
                            Button("Go") {
                                let url = URL(string: "http://maps.apple.com/?address=\(String(describing: restaurant.address1))+\(restaurant.city)")
                                UIApplication.shared.open(url!)
                            }
                        }

                        Button {
                            confirmYelp = true
                        }label: {
                            Text("    See More")
                                .frame(width: 110, height: 25)
                                .background(Color.yelpRed)
                                .foregroundStyle(.white)
                                .cornerRadius(20)
                                .font(.subheadline)
                                .overlay(
                                    Circle()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(.black)
                                        .padding(.trailing, 85)
                                )
                                .overlay(
                                    Circle()
                                        .frame(width: 22, height: 22)
                                        .padding(.trailing, 85)
                                        .foregroundStyle(.white)
                                        
                                        .overlay(
                                            Image("yelp_burst")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 18, height: 18)
                                                .foregroundStyle(Color.yelpRed)
                                                .fontWeight(.semibold)
                                                .font(.footnote)
                                                .padding(.trailing, 85)
                                                .foregroundStyle(.black)
                                        )
                                )
                        }.alert("Open Yelp?", isPresented: $confirmYelp) {
                            Button("Cancel") { }
                            Button("Go") {
                                if let yelpUrl = URL(string: restaurant.url) {
                                    UIApplication.shared.open(yelpUrl)
                                }
                            }
                        }
                       
                    }.padding(.trailing, 10)
                    ImageView(urlString: restaurant.imageUrl)
                        .frame(width: 120, height: 100)
                    
                }.frame(width: 265)
                HStack {
                    Text("\(restaurant.displayPhone)")
                    Text("*")
                    Text("\(restaurant.price)")
                    Text("*")
                    Text(String(format: "%.1f mi", restaurant.distance / 1600))

                }.font(.subheadline)
                    .foregroundStyle(.black)

                

            }
            .frame(width: 265, height: 190)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 10, x: -5, y: 5)
                    .shadow(radius: 5)
                    .frame(width: 275, height: 200)
                    .padding(.vertical, 20)
            )
        }
    }
}

func getStarImage(rating: Double) -> String {
    let ratingInt = (rating * 2).rounded() / 2
    switch ratingInt {
    case 0:
        return "yelp0Star"
    case 0.5:
        return "yelp0.5Star"
    case 1:
        return "yelp1Star"
    case 1.5:
        return "yelp1.5Star"
    case 2:
        return "yelp2Star"
    case 2.5:
        return "yelp2.5Star"
    case 3:
        return "yelp3Star"
    case 3.5:
        return "yelp3.5Star"
    case 4:
        return "yelp4Star"
    case 4.5:
        return "yelp4.5Star"
    case 5:
        return "yelp5Star"
    default:
        return ""
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(restaurant: RestaurantViewModel.example)
    }
}

