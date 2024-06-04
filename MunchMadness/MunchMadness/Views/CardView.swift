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
//    var directionsLocation: String {
//        let addressPieces = [restaurant.address1, restaurant.city].filter { (($0?.isEmpty) == nil) }
//        return addressPieces.joined(seperator: "+")
//    }
    
    
    var body: some View {
        VStack(alignment: .leading){
            VStack() {
                    Text(restaurant.name)
                    .foregroundStyle(.black)
                    .font(.title2)
                        .multilineTextAlignment(.center)
//                        .italic()
                        .frame(width: 265)
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", restaurant.rating))
                                .fontWeight(.semibold)
                            Text("(\(restaurant.reviewCount)) on Yelp")
                                .foregroundStyle(.black)
                                .font(.subheadline)
                        }.foregroundStyle(.black)

                    
                
                HStack {
                    VStack(alignment: .center) {
                        Button {
                            let url = URL(string: "http://maps.apple.com/?address=\(String(describing: restaurant.address1))+\(restaurant.city)")
                            UIApplication.shared.open(url!)
                            
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

                        Button {
                            if let yelpUrl = URL(string: restaurant.url) {
                                UIApplication.shared.open(yelpUrl)
                            }
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
                                            Image(systemName: "chevron.forward.2")
                                                .foregroundStyle(Color.yelpRed)
                                                .fontWeight(.semibold)
                                                .font(.footnote)
                                                .padding(.trailing, 85)
                                                .foregroundStyle(.black)
                                        )
                                )
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
//            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 10, x: -5, y: 5)
                    .shadow(radius: 5)
                    .frame(width: 275, height: 200)
                    .padding(.vertical, 20)
            )
//            .offset(x: offset.width, y: offset.height * 0.4)
//                .rotationEffect(.degrees(Double(offset.width / 40)))
//                .gesture(DragGesture()
//                    .onChanged { gesture in
//                        offset = gesture.translation
//                    })
//            .padding()
//            ShareLink(item: (URL(string: restaurant.url) ?? yelpHomePage)!)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(restaurant: RestaurantViewModel.example)
    }
}

