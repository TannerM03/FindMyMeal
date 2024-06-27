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
    @State private var limit = 10
    @State private var radius = 0
    
    @State private var prices: [Int] = []
    
    @State var latitude: CLLocationDegrees
    @State var longitude: CLLocationDegrees
    
    @State var selectedLongitude: CLLocationDegrees = 0
    @State var selectedLatitude: CLLocationDegrees = 0
    
    @State private var usingPersonalLocation = false
    
    @State private var isEditing = false
    @State private var isOpen = false
    @State private var userMood = ""
    @State private var isSwiperViewActive = false
    
    @ObservedObject var vm = RestaurantListViewModel()
    @ObservedObject var locationManager: LocationManager
    
    @State private var mapView: Bool = false
    
    @State private var selectLocationPressed = false
    @State private var useMyLocationPressed = false
    
    
    @Binding var selectedTab: String
    
    @Binding var savedRestaurant: RestaurantViewModel?
    
    @Binding var restaurants: [RestaurantViewModel]
    @Binding var isNewSearch: Bool
    @Binding var topIndex: Int
    @Binding var bottomIndex: Int
    @Binding var searching: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var showTitle = true
    @State private var instructionsClicked = true
    
    @Binding var firstSearch: Bool
    @State var locationPressed = false
    @Binding var animationCount: Int
            
    var body: some View {
        GeometryReader { geometry in
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors:[Color.uncBlue, Color.darkerblue]), startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: .bottom)

                    HStack {
                        Spacer()
                        VStack(spacing: getSpacing(for: geometry.size)) {
                            HStack {
                                UserLocationBtn(locationManager: locationManager, latitude: $latitude, longitude: $longitude, usingPersonalLocation: $usingPersonalLocation, selectLocationPressed: $selectLocationPressed, useMyLocationPressed: $useMyLocationPressed, locationPressed: $locationPressed)
                                
                                Text("OR")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .shadow(color:.gray, radius: 5)
                                
                                SelectLocationBtn(usingPersonalLocation: $usingPersonalLocation, mapView: $mapView, selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude, selectLocationPressed: $selectLocationPressed, useMyLocationPressed: $useMyLocationPressed, showTitle: $showTitle, selectedTab: $selectedTab, locationPressed: $locationPressed)
                                
                            }
                            
                            
                            //get distance parameter
                            HStack {
                                Text("Maximum distance?")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .shadow(color:.gray, radius: 5)
                                Spacer()
                                
                                DistancePicker(distance: $distance)
                                
                            }.frame(width: 328)
                            
                            //get price range
                            Text("Price Range:")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color:.gray, radius: 5)
                                .padding(.trailing, 200)
                                .padding(.bottom, -15)
                            
                            PricesFilter(prices: $prices)
                            
                            HStack {
                                Text("Number of options?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .shadow(color:.gray, radius: 5)
                                Spacer()
                                CountPicker(count: $limit)
                            }.frame(width: 328)
                            
                            
                            //get terms
                            Text("What are you craving?")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color:.gray, radius: 5)
                                .padding(.trailing, 103)
                                .padding(.bottom, -10)
                            TextField("ex: fast food, breakfast, chinese", text: $userMood)
                                .foregroundStyle(Color.black)
                                .multilineTextAlignment(.center)
                                .frame(width: 300, height: 40)
                                .background(.white)
                                .cornerRadius(20)
                                .shadow(radius: 2)
                                .submitLabel(.done)
                            //get whether they want it to be open
                            Toggle("Only open restaurants?", isOn: $isOpen)
                                .frame(width: 331)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .tint(Color.uncBlue)
                            
                            
                            //submit button that takes you to SwiperView()
                            SubmitBtn(distance: $distance, userMood: $userMood, prices: $prices, usingPersonalLocation: $usingPersonalLocation, radius: $radius, isSwiperViewActive: $isSwiperViewActive, isOpen: $isOpen, latitude: $latitude, longitude: $longitude, selectedLongitude: $selectedLongitude, selectedLatitude: $selectedLatitude, isNewSearch: $isNewSearch, selectedTab: $selectedTab, savedRestaurant: $savedRestaurant, restaurants: $restaurants, topIndex: $topIndex, bottomIndex: $bottomIndex, searching: $searching, firstSearch: $firstSearch, limit: $limit, locationPressed: $locationPressed, animationCount: $animationCount)
                                .padding(.bottom, 35)
                            
                        }
                        .padding(.top, 91)
                        Spacer()
                    
                }
                
            }.padding(.top, -91)
                .overlay {
                    if (instructionsClicked) {
                        Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                            .gesture(
                                TapGesture()
                                    .onEnded { _ in
                                        instructionsClicked = false
                                    }
                            )
                        InstructionsView(selectedTab: $selectedTab)
                            .padding(6)
                            .multilineTextAlignment(.leading)
                            .frame(width: 350, height: 435, alignment: .topLeading)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1)
                                    .fill(Color.white)
                            }.offset(y: getInstructionsOffset(for: geometry.size))
                            .overlay(alignment: .topTrailing) {
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
                                    .offset(y: getInstructionsOffset(for: geometry.size))
                            }
                    }
                }
            
        }.overlay {
            if showTitle {
                
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
                        Text("Filters")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.darkerblue)
                        Spacer()
                        Button {
                            instructionsClicked = true
                        }label: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color.darkerblue)
                                .padding(.trailing, 15)
                        }
                    }
                    .background {
                        Rectangle()
                            .frame(width: 500, height: 122)
                            .foregroundColor(.white)
                            .padding(.bottom, 50)
                        if instructionsClicked {
                            Color.black.opacity(0.3)
                                .padding(.bottom, 50)
                        }
                    }
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .onTapGesture {
                        instructionsClicked = false
                    }
            }
            }
        }.preferredColorScheme(.light)
            
        
        
    }
    
    
}





func getSpacing(for size: CGSize) -> CGFloat {
    if size.height > 711 {
        return 35
    } else if size.height > 700 {
        return 25
    } else {
        return 20
    }
}

func getInstructionsOffset(for size: CGSize) -> CGFloat {
    if size.height > 930 {
        return -46
    } else if size.height > 920 {
        return -48
    } else if size.height > 711 {
        return -48
    } else if size.height > 709 {
        return -45
    } else if size.height > 678 {
        return -48
    } else {
        return -48
    }
}

struct PricesFilter: View {
    @Binding var prices: [Int]
    var body: some View {
        HStack(spacing: 2) {
            Button {
                updatePrice(1)
                
            } label: {
                Text("$")
                    .frame(width: 82, height: 70)
                        .tint(prices.contains(1) ? Color.white : Color.darkerblue)
                        .background(prices.contains(1) ? Color.darkerblue : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            Button {
                updatePrice(2)
                
            } label: {
                Text("$$")
                    .frame(width: 82, height: 70)
                        .tint(prices.contains(2) ? Color.white : Color.darkerblue)
                        .background(prices.contains(2) ? Color.darkerblue : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            Button {
                updatePrice(3)
                
            } label: {
                Text("$$$")
                    .frame(width: 82, height: 70)
                        .tint(prices.contains(3) ? Color.white : Color.darkerblue)
                        .background(prices.contains(3) ? Color.darkerblue : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            Button {
                updatePrice(4)
                
            } label: {
                Text("$$$$")
                    .frame(width: 82, height: 70)
                        .tint(prices.contains(4) ? Color.white : Color.darkerblue)
                        .background(prices.contains(4) ? Color.darkerblue : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .font(.title2)
        .fontWeight(.medium)
    }
    func updatePrice(_ price: Int) {
            if prices.contains(price) {
                prices.removeAll(where: { $0 == price })
            } else {
                prices.append(price)
            }
        }
}

struct DistancePicker: View {
    @Binding var distance: Int
    var body: some View {
        Picker("Distance", selection: $distance) {
            ForEach(1...25, id: \.self) { mile in
                Text("\(mile) mi")
            }
        }.background(Color.white)
            .cornerRadius(20)
            .accentColor(.black)
    }
}

struct CountPicker: View {
    @Binding var count: Int
    var body: some View {
        Picker("Count", selection: $count) {
            ForEach(5...50, id: \.self) { count in
                Text("\(count)")
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
    @Binding var showTitle: Bool
    @Binding var selectedTab: String
    @Binding var locationPressed: Bool
    var body: some View {
        Button {
            usingPersonalLocation = false
            selectLocationPressed = true
            useMyLocationPressed = false
            mapView.toggle()
            showTitle = false
            locationPressed = false
        } label: {
            VStack {
                Text("SELECT")
                Text("LOCATION")
            }.font(.headline)
                .foregroundColor(selectLocationPressed ? Color.white : Color.darkerblue)
                .padding()
                    .foregroundColor(.black)
                    .frame(width: 150, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(selectLocationPressed ? Color.darkerblue : Color.white)
                    ).navigationDestination(isPresented: $mapView) {
                        SelectLocationView(selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude, showTitle: $showTitle, selectedTab: $selectedTab, locationPressed: $locationPressed).toolbar(.hidden)
                    }
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
    @Binding var locationPressed: Bool
    @State private var userLocationAlert = false
    var body: some View {
        Button {
            if locationManager.authStatus == .denied {
                userLocationAlert = true
            } else {
                userLocationAlert = false
                Task {
                    locationManager.startFetchingCurrentLocation()
                    
                    //this gives it time to actually fetch the location before the if
                    //statement, not sure if this is best practice (probably not)
                    try await Task.sleep(nanoseconds: 0_050_000_000)
                    
                    if let location = locationManager.userLocation {
                        latitude = location.coordinate.latitude
                        longitude = location.coordinate.longitude
                        usingPersonalLocation = true
                        
                    }
                    else {
                        //                    print("User location not available")
                    }
                }
                selectLocationPressed = false
                useMyLocationPressed = true
                locationPressed = true
            }
        } label: {
            VStack {
                Text("CURRENT")
                Text("LOCATION")
            }.font(.headline)
                .foregroundColor(useMyLocationPressed ? Color.white : Color.darkerblue)
                .padding()
                    .foregroundColor(.black)
                    .frame(width: 150, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(useMyLocationPressed ? Color.darkerblue : Color.white)
                        
                    )
            
        }.alert("Must allow location access to use personal location", isPresented: $userLocationAlert) {
            Button("OK", role: .cancel) {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }
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
    @Binding var topIndex: Int
    @Binding var bottomIndex: Int
    @Binding var searching: Bool
    @Binding var firstSearch: Bool
    @Binding var limit: Int
    @Binding var locationPressed: Bool
    @State private var showAlert = false
    @State private var pricesAlert = false
    @Binding var animationCount: Int
    
    var body: some View {

        @State var profile = false
        
        Button(action: {
            if (!locationPressed) {
                showAlert = true
            } else if prices == [] {
                pricesAlert = true
            }
            else {
                pricesAlert = false
                firstSearch = false
                searching = true
                topIndex = 0
                bottomIndex = 1
                restaurants = []
                isNewSearch = true
                radius = distance * 1600 - distance * 50
                vm.term = userMood
                vm.prices = prices
                animationCount = 0
                if usingPersonalLocation == true {
                    Task {
                        restaurants = await vm.getPlaces(with: userMood, longitude: longitude, latitude: latitude, radius: radius, openNow: isOpen, prices: prices, limit: limit)
                        searching = false
                    }
                    
                }
                else if usingPersonalLocation == false {
                    Task {
                        restaurants = await vm.getPlaces(with: userMood, longitude: selectedLongitude, latitude: selectedLatitude, radius: radius, openNow: isOpen, prices: prices, limit: limit)
                        searching = false
                    }
                }
                else {
                    searching = false
                }
                isSwiperViewActive = true
                selectedTab = "2"
            }
        }, label: {
            Text("SUBMIT")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .frame(width: 150, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)

                    
                )
        }).alert("Select a location", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }.alert("Select your price range", isPresented: $pricesAlert) {
            Button("OK", role: .cancel) { }
        }

    }
}
