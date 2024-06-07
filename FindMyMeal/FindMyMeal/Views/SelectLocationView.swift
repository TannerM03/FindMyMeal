//
//  SelectLocationView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 4/2/24.
//

import SwiftUI
import MapKit

struct SelectLocationView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var cameraPosition: MapCameraPosition = .region(.starterRegion)
    @State private var searchText = ""
    @State private var results: [MKMapItem] = []
    @State private var showSubmit = false
    
    @State private var backToFilter: Bool = false
    
    @Binding var selectedLatitude: CLLocationDegrees
    @Binding var selectedLongitude: CLLocationDegrees
    
    
    
    @State private var onLocationSelected: ((CLLocationDegrees, CLLocationDegrees) -> Void)?
    
    @State private var swiperTime: Bool = false
    
    @State private var searched: Bool = false
    @Binding var showTitle: Bool
    @Binding var selectedTab: String
    @State private var dismissView: Bool = false
    @Binding var locationPressed: Bool
    
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
                    VStack(alignment: .leading) {
                        HStack {
                            Button {
                                if selectedTab == "1" {
                                    showTitle = true
                                }
                                presentationMode.wrappedValue.dismiss()
                            }label: {
                                Image(systemName: "chevron.left")
                                Text("Back")
                                    .padding(0)
                            }
                        }.foregroundStyle(Color.darkerblue)
                        .padding(.leading, 20)
                        TextField("Search for city or address", text: $searchText)
                            .foregroundStyle(Color.black)
                            .font(.subheadline)
                            .padding(12)
                            .background{
                                Rectangle()
                                    .fill(.white)
                                }
                            .padding()
                            .shadow(radius: 10)
                        
                            .overlay(alignment: .trailing) {
                                Button {
                                    searched = true
                                    print("searched")
                                    
                                    Task { await searchPlaces()
                                        if let firstItem = results.first {
                                            var resultLocation: CLLocationCoordinate2D {
                                                return .init(latitude: firstItem.placemark.coordinate.latitude, longitude: firstItem.placemark.coordinate.longitude)
                                            }
                                            var resultRegion: MKCoordinateRegion {
                                                return .init(center: resultLocation,
                                                             latitudinalMeters: 10000, longitudinalMeters: 10000)
                                            }
                                            cameraPosition = .region(resultRegion)
                                            selectedLatitude = firstItem.placemark.coordinate.latitude
                                            selectedLongitude = firstItem.placemark.coordinate.longitude
                                            print("Latitude: \(firstItem.placemark.coordinate.latitude)")
                                            print("Longitude: \(firstItem.placemark.coordinate.longitude)")
                                            
                                        }
                                    }
                                }label: {
                                    Text("Search")
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 5)
                                        .font(.subheadline)
                                        .background(
                                            RoundedRectangle(cornerRadius: 1)
                                                .fill(Color.uncBlue)
                                        )
                                }.padding(.trailing, 17)
                                
                            }
                    }.padding(.top, 10)

                    Spacer()
                    //button that gets latitude and longitude, brings you back to the filters page
                    if searched == true {
                        Button (action: {
                            swiperTime.toggle()
                            print("button clicked")
                            if let firstItem = results.first {
                                print("past first param")
                                print("\(firstItem.placemark.coordinate.latitude)")
                                    selectedLongitude = firstItem.placemark.coordinate.longitude
                                    selectedLatitude = firstItem.placemark.coordinate.latitude
                                    print("Longitude: \(selectedLongitude)")
                            }
                            presentationMode.wrappedValue.dismiss()
                            showTitle = true
                            locationPressed = true
                        }, label: {
                            Text("Submit")
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
                            .padding(.bottom, 20)
                        
                    }
                    

                }
            }
            .onSubmit(of: .text) {
                searched = true
                //this searches for what the user inputs
                Task { await searchPlaces()
                    if let firstItem = results.first {
                        var resultLocation: CLLocationCoordinate2D {
                            return .init(latitude: firstItem.placemark.coordinate.latitude, longitude: firstItem.placemark.coordinate.longitude)
                        }
                        var resultRegion: MKCoordinateRegion {
                            return .init(center: resultLocation,
                                         latitudinalMeters: 10000, longitudinalMeters: 10000)
                        }
                        cameraPosition = .region(resultRegion)
                        selectedLatitude = firstItem.placemark.coordinate.latitude
                        selectedLongitude = firstItem.placemark.coordinate.longitude
                        print("Latitude: \(firstItem.placemark.coordinate.latitude)")
                        print("Longitude: \(firstItem.placemark.coordinate.longitude)")
                        
                    }
                }
            }

        }.preferredColorScheme(.light)
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


struct SelectLocationView_Previews: PreviewProvider {
    @State static var selectedLatitude: CLLocationDegrees = 40.7128
    @State static var selectedLongitude: CLLocationDegrees = -74.0060
    @State static var showTitle: Bool = false
    @State static var selectedTab: String = "1"
    @State static var locationPressed: Bool = true

    static var previews: some View {
        SelectLocationView(
            selectedLatitude: $selectedLatitude,
            selectedLongitude: $selectedLongitude,
            showTitle: $showTitle,
            selectedTab: $selectedTab,
            locationPressed: $locationPressed
        )
    }
}
