//
//  LocationManager.swift
//  huda
//
//  Created by Ali Macky on 11/30/25.
//

import Foundation
import CoreLocation
import SwiftUI

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    
    var location: CLLocationCoordinate2D?
    var status: CLAuthorizationStatus = .notDetermined
    
    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.distanceFilter = 1000
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func start() {
        manager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {return}
        self.location = latestLocation.coordinate
        
        PrayerManager.shared.calculatePrayers(at: latestLocation.coordinate)
        PrayerManager.shared.calculateQibla(at: latestLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error.localizedDescription)")
    }
}
