//
//  LocationManager.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/19/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var hasLocationAccess: Bool = false
    @Published var authStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func requestLocationAccess() {
        manager.requestWhenInUseAuthorization()
    }
    func startFetchingCurrentLocation() {
            manager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func stopFetchingCurrentLocaiton() {
        manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("DEBUG: not determined")
            hasLocationAccess = false
        case .restricted:
            print("DEBUG: restricted")
            hasLocationAccess = false
        case .denied:
            print("DEBUG: denied")
            hasLocationAccess = false
        case .authorizedAlways:
            print("DEBUG: Auth always")
            hasLocationAccess = true
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use")
            hasLocationAccess = true
        @unknown default:
            hasLocationAccess = false
            break
        }
        authStatus = status
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.userLocation = location
    }
    
}
