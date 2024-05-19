//
//  FilterView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI
import CoreLocation

struct FilterView: View {

    @State private var distance = 5
    @State private var radius = 0
    
    @State private var prices: [Int] = []
    
    @State var latitude: CLLocationDegrees
    @State var longitude: CLLocationDegrees
    
    @State var selectedLongitude: CLLocationDegrees = 0
    @State var selectedLatitude: CLLocationDegrees = 0
    
    @State private var usingPersonalLocation = false
    
    @State private var isEditing = false
    @State private var isOpen = true
    @State private var userMood = ""
    @State private var isSwiperViewActive = false
    
    @ObservedObject var vm = RestaurantListViewModel()
    @ObservedObject var locationManager: LocationManager
    
    @State private var mapView: Bool = false
    
    @State private var selectLocationPressed = false
    @State private var useMyLocationPressed = false
    
    @State private var isNewSearch = false
    
    @Binding var selectedTab: String
    
    @Binding var savedRestaurant: RestaurantViewModel?
    
    @State var restaurants: [RestaurantViewModel] = []

    
            
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.uncBlue
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Filters")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.darkerblue)
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
                        UserLocationBtn(locationManager: locationManager, latitude: $latitude, longitude: $longitude, usingPersonalLocation: $usingPersonalLocation, selectLocationPressed: $selectLocationPressed, useMyLocationPressed: $useMyLocationPressed)
                        
                        SelectLocationBtn(usingPersonalLocation: $usingPersonalLocation, mapView: $mapView, selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude, selectLocationPressed: $selectLocationPressed, useMyLocationPressed: $useMyLocationPressed)
                        
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
                        
                        DistancePicker(distance: $distance)
                        
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
                        .tint(Color.darkerblue)
                        .padding(.bottom, 20)
                    
                    //submit button that takes you to SwiperView()
                    SubmitBtn(distance: $distance, userMood: $userMood, prices: $prices, usingPersonalLocation: $usingPersonalLocation, radius: $radius, isSwiperViewActive: $isSwiperViewActive, isOpen: $isOpen, latitude: $latitude, longitude: $longitude, selectedLongitude: $selectedLongitude, selectedLatitude: $selectedLatitude, isNewSearch: $isNewSearch, selectedTab: $selectedTab, savedRestaurant: $savedRestaurant, restaurants: $restaurants)
                    
                    Spacer()
                }

            }
            
        }
        
        
    }
    
    
}



//#Preview {
//    FilterView(latitude: 40.7128, longitude: -74.0060, vm: RestaurantListViewModel(), locationManager: LocationManager())
//}

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
                .tint(prices.contains(1) ? Color.white : Color.darkerblue)
                .background(prices.contains(1) ? Color.darkerblue : Color.white)
                .border(.black)
            Button {
                updatePrice(2)
                print("\(prices)")
                
            } label: {
                Text("$$")
            }.frame(width: 82, height: 70)
                .tint(prices.contains(2) ? Color.white : Color.darkerblue)
                .background(prices.contains(2) ? Color.darkerblue : Color.white)
                .border(.black)
            Button {
                updatePrice(3)
                print("\(prices)")
                
            } label: {
                Text("$$$")
            }.frame(width: 82, height: 70)
                .tint(prices.contains(3) ? Color.white : Color.darkerblue)
                .background(prices.contains(3) ? Color.darkerblue : Color.white)
                .border(.black)
            Button {
                updatePrice(4)
                print("\(prices)")
                
            } label: {
                Text("$$$$")
            }.frame(width: 82, height: 70)
                .tint(prices.contains(4) ? Color.white : Color.darkerblue)
                .background(prices.contains(4) ? Color.darkerblue : Color.white)
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

struct DistancePicker: View {
    @Binding var distance: Int
    var body: some View {
        Picker("Distance", selection: $distance) {
            ForEach(0...25, id: \.self) { mile in
                Text("\(mile) mi")
            }
        }.background(Color.white)
            .cornerRadius(20)
            .accentColor(.black)
    }
}

struct SelectLocationBtn: View {
    @Binding var usingPersonalLocation: Bool
    @Binding var mapView: Bool
    @Binding var selectedLatitude: CLLocationDegrees
    @Binding var selectedLongitude: CLLocationDegrees
    @Binding var selectLocationPressed: Bool
    @Binding var useMyLocationPressed: Bool
    
    var body: some View {
        Button {
            usingPersonalLocation = false
            selectLocationPressed = true
            useMyLocationPressed = false
            mapView.toggle()
        } label: {
            VStack {
                Text("SELECT")
                Text("LOCATION")
            }.font(.headline)
                .italic()
                .foregroundColor(selectLocationPressed ? Color.white : Color.darkerblue)
        }.padding()
            .foregroundColor(.black)
            .frame(width: 150, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(selectLocationPressed ? Color.darkerblue : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.black, lineWidth: 1)
                    )
                
            ).navigationDestination(isPresented: $mapView) {
                SelectLocationView(selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude)
            }
    }
}

struct UserLocationBtn: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var latitude: CLLocationDegrees
    @Binding var longitude: CLLocationDegrees
    @Binding var usingPersonalLocation: Bool
    @Binding var selectLocationPressed: Bool
    @Binding var useMyLocationPressed: Bool
    var body: some View {
        Button {
            Task {
                locationManager.startFetchingCurrentLocation()
                
                //this gives it time to actually fetch the location before the if
                //statement, not sure if this is best practice (probably not)
                try await Task.sleep(nanoseconds: 0_050_000_000)
                
                if let location = locationManager.userLocation {
                    latitude = location.coordinate.latitude
                    longitude = location.coordinate.longitude
                    print("got latitude and longitude")
                    print("Latitude: \(latitude)\nLongitude: \(longitude)")
                    usingPersonalLocation = true
                    
                }
                else {
                    //might wanna ask for location again here
                    print("User location not available")
                }
            }
            selectLocationPressed = false
            useMyLocationPressed = true
        } label: {
            VStack {
                Text("USE MY")
                Text("LOCATION")
            }.font(.headline)
                .italic()
                .foregroundColor(useMyLocationPressed ? Color.white : Color.darkerblue)
            
        }.padding()
            .foregroundColor(.black)
            .frame(width: 150, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(useMyLocationPressed ? Color.darkerblue : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.black, lineWidth: 1)
                    )
                
            )
    }
}

struct SubmitBtn: View {
    @Binding var distance: Int
    @Binding var userMood: String
    @Binding var prices: [Int]
    @Binding var usingPersonalLocation: Bool
    @Binding var radius: Int
    @Binding var isSwiperViewActive: Bool
    @Binding var isOpen: Bool
    @Binding var latitude: CLLocationDegrees
    @Binding var longitude: CLLocationDegrees
    @Binding var selectedLongitude: CLLocationDegrees
    @Binding var selectedLatitude: CLLocationDegrees
    @ObservedObject var vm = RestaurantListViewModel()
    @Binding var isNewSearch: Bool
    @Binding var selectedTab: String
    
    @Binding var savedRestaurant: RestaurantViewModel?
    @Binding var restaurants: [RestaurantViewModel]


    var body: some View {

        @State var profile = false
        
        Button(action: {
            restaurants = []
            isNewSearch = true
            radius = distance * 1600
            vm.term = userMood
            vm.prices = prices
            if usingPersonalLocation == true {
                    print("restaurants before getPlaces: \(restaurants)")
                    restaurants = vm.getPlaces(with: userMood, longitude: longitude, latitude: latitude, radius: radius, openNow: isOpen, prices: prices)
                    print("restaurants after getPlaces: \(restaurants) + isSwiperViewActice: \(isSwiperViewActive)")
                    print("after set to true: \(isSwiperViewActive) + restaurants: \(restaurants)")
            }
            else if usingPersonalLocation == false {
                restaurants = vm.getPlaces(with: userMood, longitude: selectedLongitude, latitude: selectedLatitude, radius: radius, openNow: isOpen, prices: prices)
            }
            else {
                print("Location not available")
            }
            isSwiperViewActive = true
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
            SwiperView(vm: vm, selectedTab: $selectedTab, savedRestaurant: $savedRestaurant, restaurants: $restaurants)
        }
    }
}
