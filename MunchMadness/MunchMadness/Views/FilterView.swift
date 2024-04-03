//
//  FilterView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI
import CoreLocation

struct FilterView: View {

    @State private var distance = 0
    @State private var radius = 0
    
    @State private var prices: [Int] = []
    
    @State var latitude: CLLocationDegrees
    @State var longitude: CLLocationDegrees
    

    @State private var isEditing = false
    @State private var isOpen = true
    @State private var userMood = ""
    @State private var isSwiperViewActive = false
    
    @ObservedObject var vm = RestaurantListViewModel()
    @ObservedObject var locationManager: LocationManager
    
    @State private var mapView: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Filters")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.headers)
                        .italic()
                        .background(
                            Rectangle()
                                .frame(width: 400, height: 120)
                                .padding(.bottom, 50)
                                .foregroundColor(.white)
                        )
                    Spacer()
                    
                    //add the ability to set location
                    HStack {
                        Button {
                            locationManager.startFetchingCurrentLocation()
                            
                            if let location = locationManager.userLocation {
                                latitude = location.coordinate.latitude
                                longitude = location.coordinate.longitude
                                print("got latitude and longitude")
                                print("Latitude: \(latitude)\nLongitude: \(longitude)")
                            } else {
                                // Handle the case where userLocation is nil
                                // You can display an alert or take appropriate action
                                print("User location not available")
                            }
                        } label: {
                            VStack {
                                Text("USE MY")
                                Text("LOCATION")
                            }.font(.headline)
                                .italic()

                        }.padding()
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
                        Button {
                            mapView.toggle()
                        } label: {
                            VStack {
                                Text("SELECT")
                                Text("LOCATION")
                            }.font(.headline)
                                .italic()
                        }.padding()
                            .foregroundColor(.black)
                            .frame(width: 150, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                
                            ).navigationDestination(isPresented: $mapView) {
                                SelectLocationView()
                            }
                    }
                    .padding(.bottom, 30)
                    
                    
                    //get distance parameter
                    HStack {
                        Text("How far are you willing \nto go?")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.trailing, 10)
                            .shadow(color:.gray, radius: 5)
                        Picker("Distance", selection: $distance) {
                            ForEach(0...25, id: \.self) { mile in
                                Text("\(mile) mi")
                            }
                        }.background(Color.white)
                            .cornerRadius(20)
                            .accentColor(.black)
                    }.padding(.bottom, 30)
                    
                    //get price range
                    Text("Price Range:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color:.gray, radius: 5)
                        .padding(.trailing, 200)
                    
                    PricesFilter(prices: $prices)
                    
                    
                    //get terms
                    Text("What are you craving?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color:.gray, radius: 5)
                        .padding(.trailing, 100)
                    TextField("ex: fast food, breakfast, chinese", text: $userMood)
                        .multilineTextAlignment(.center)
                        .frame(width: 300, height: 40)
                        .background(.white)
                        .cornerRadius(20)
                        .shadow(radius: 2)
                        .padding(.bottom, 20)
                    //get whether they want it to be open
                    Toggle("Only show open restaurants", isOn: $isOpen)
                        .padding(.horizontal, 20)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color:.gray, radius: 5)
                        .tint(Color.headers)
                        .padding(.bottom, 20)
                    
                    //submit button that takes you to SwiperView()
                    Button(action: {
                        radius = distance * 1609
                        vm.term = userMood
                        vm.prices = prices
                        if let location = locationManager.userLocation {
                            vm.getPlaces(with: userMood, longitude: longitude, latitude: latitude, radius: radius, openNow: isOpen, prices: prices)
                            isSwiperViewActive = true
                        } else {
                            // Handle the case where userLocation is nil
                            // You can display an alert or take appropriate action
                            print("User location not available")
                        }
                    }, label: {
                        Text("SUBMIT")
                            .font(.title2)
                            .fontWeight(.medium)
                            .italic()
                            .foregroundColor(.black)
                            .frame(width: 150, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                
                            )
                            .padding(.bottom, 20)
                    }).navigationDestination(isPresented: $isSwiperViewActive) {
                        SwiperView(vm: vm)
                    }
                    Spacer()
                }

            }
            
        }
        
        
    }
    
    
}



#Preview {
    FilterView(latitude: 40.7128, longitude: -74.0060, vm: RestaurantListViewModel(), locationManager: LocationManager())
}

struct PricesFilter: View {
    @Binding var prices: [Int]
    var body: some View {
        HStack(spacing: 0) {
            Button {
                updatePrice(1)
                print("\(prices)")
                
            } label: {
                Text("$")
            }.frame(width: 82, height: 70)
                .tint(prices.contains(1) ? Color.white : Color.headers)
                .background(prices.contains(1) ? Color.headers : Color.white)
                .border(.black)
            Button {
                updatePrice(2)
                print("\(prices)")
                
            } label: {
                Text("$$")
            }.frame(width: 82, height: 70)
                .tint(prices.contains(2) ? Color.white : Color.headers)
                .background(prices.contains(2) ? Color.headers : Color.white)
                .border(.black)
            Button {
                updatePrice(3)
                print("\(prices)")
                
            } label: {
                Text("$$$")
            }.frame(width: 82, height: 70)
                .tint(prices.contains(3) ? Color.white : Color.headers)
                .background(prices.contains(3) ? Color.headers : Color.white)
                .border(.black)
            Button {
                updatePrice(4)
                print("\(prices)")
                
            } label: {
                Text("$$$$")
            }.frame(width: 82, height: 70)
                .tint(prices.contains(4) ? Color.white : Color.headers)
                .background(prices.contains(4) ? Color.headers : Color.white)
                .border(.black)
        }
        .font(.title2)
        .fontWeight(.medium)
        .padding(.bottom, 20)
    }
    func updatePrice(_ price: Int) {
            if prices.contains(price) {
                prices.removeAll(where: { $0 == price })
            } else {
                prices.append(price)
            }
            print(prices)
        }
}
