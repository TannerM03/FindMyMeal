//
//  SelectLocationView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 4/2/24.
//

import SwiftUI
import MapKit

struct SelectLocationView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.starterRegion)
    @State private var searchText = ""
    @State private var results: [MKMapItem] = []
    
    @State private var backToFilter: Bool = false
    
    @State private var selectedLatitude: CLLocationDegrees = 40.7128
    @State private var selectedLongitude: CLLocationDegrees = -74.0060
    
    @State private var onLocationSelected: ((CLLocationDegrees, CLLocationDegrees) -> Void)?
    
    @State private var swiperTime: Bool = false
    
    var body: some View {
        NavigationView {
            Map(position: $cameraPosition) {
                ForEach(results, id: \.self) { item in
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                }
            }
            .overlay(alignment: .top) {
                VStack {
                    //user input location
                    TextField("search for city or address", text: $searchText)
                        .font(.subheadline)
                        .padding(12)
                        .background(.white)
                        .padding()
                        .shadow(radius: 10)
                    Spacer()
                    //button that gets latitude and longitude, brings you back to the filters page
                    Button (action: {
                        swiperTime.toggle()
                        print("button clicked")
                        if let firstItem = results.first {
                            print("past first param")
                            print("\(firstItem.placemark.coordinate.latitude)")
//                            onLocationSelected!(firstItem.placemark.coordinate.latitude, firstItem.placemark.coordinate.longitude)
                                selectedLongitude = firstItem.placemark.coordinate.longitude
                                selectedLatitude = firstItem.placemark.coordinate.latitude
                                print("Longitude: \(selectedLongitude)")
                        }
                    }, label: {
                        Text("Submit")
                    })
//                    .navigationDestination(isPresented: $backToFilter) {
//                        FilterView(latitude: selectedLatitude, longitude: selectedLongitude, vm: RestaurantListViewModel(), locationManager: LocationManager())
//                    }
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
                    NavigationLink(
                                        destination: FilterView(latitude: selectedLatitude, longitude: selectedLongitude, vm: RestaurantListViewModel(), locationManager: LocationManager()),
                                        isActive: $swiperTime
                                    ) {
                                        EmptyView()
                                    }
                        
                }
            }
            .onSubmit(of: .text) {
                //this searches for what the user inputs
                Task { await searchPlaces()
                    if let firstItem = results.first {
                        var resultLocation: CLLocationCoordinate2D {
                            return .init(latitude: firstItem.placemark.coordinate.latitude, longitude: firstItem.placemark.coordinate.longitude)
                        }
                        var resultRegion: MKCoordinateRegion {
                            return .init(center: resultLocation,
                                         latitudinalMeters: 50000, longitudinalMeters: 50000)
                        }
                        cameraPosition = .region(resultRegion)
                        selectedLatitude = firstItem.placemark.coordinate.latitude
                        selectedLongitude = firstItem.placemark.coordinate.longitude
                        print("Latitude: \(firstItem.placemark.coordinate.latitude)")
                        print("Longitude: \(firstItem.placemark.coordinate.longitude)")
                        
                    }
                }
            }
        }
    }
}

extension SelectLocationView {
    func searchPlaces() async {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            request.region = .starterRegion
            let results = try? await MKLocalSearch(request: request).start()
            if let firstItem = results?.mapItems.first {
                self.results = [firstItem]
            } else {
                self.results = []
            }
        }
}

extension CLLocationCoordinate2D {
    static var location: CLLocationCoordinate2D {
        return .init(latitude: 40.7128, longitude: -74.0060)
    }
}

extension MKCoordinateRegion {
    static var searchRegion: MKCoordinateRegion {
        return .init(center: .location, latitudinalMeters: 5000000, longitudinalMeters: 5000000)
    }
    static var starterRegion: MKCoordinateRegion {
        return .init(center: .location,
        latitudinalMeters: 500000, longitudinalMeters: 500000)
    }
}


#Preview {
    SelectLocationView()
}
