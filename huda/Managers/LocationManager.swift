/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * LocationManager.swift
 * This file is part of Huda.
 *
 * Huda is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Huda is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Huda. If not, see <https://www.gnu.org/licenses/>.
 */

import Foundation
import CoreLocation
import SwiftUI
import MapKit

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    
    var location: CLLocationCoordinate2D?
    var locationTitle: String?
    var status: CLAuthorizationStatus = .notDetermined
    var heading: Double = 0.0
    var headingAccuracy: Double = -1
    
    private let cacheKeys = (
        lat: "cachedLocationLatitude",
        lon: "cachedLocationLongitude",
        title: "cachedLocationTitle"
    )
    
    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.distanceFilter = 1000
        manager.headingFilter = 1
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
            if !NetworkMonitor.shared.isConnected {
                loadCachedLocation()
            } else {
                manager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        self.location = latestLocation.coordinate
        saveLocationToCache(latestLocation.coordinate)
        
        Task {
            let title = try await latestLocation.fetchCityWithContext()
            await MainActor.run {
                locationTitle = title
                saveTitleToCache(title)
            }
        }
        
        PrayerManager.shared.calculatePrayers(at: latestLocation.coordinate)
        PrayerManager.shared.calculateQibla(at: latestLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.headingAccuracy = newHeading.headingAccuracy
        if newHeading.headingAccuracy >= 0 {
            self.heading = newHeading.magneticHeading
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error.localizedDescription)")
    }
    
    func startUpdatingHeading() {
        if CLLocationManager.headingAvailable() {
            manager.startUpdatingHeading()
        }
    }
    
    func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }
    
    private func saveLocationToCache(_ coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinate.latitude, forKey: cacheKeys.lat)
        UserDefaults.standard.set(coordinate.longitude, forKey: cacheKeys.lon)
    }
    
    private func saveTitleToCache(_ title: String) {
        UserDefaults.standard.set(title, forKey: cacheKeys.title)
    }
    
    private func loadCachedLocation() {
        let lat = UserDefaults.standard.double(forKey: cacheKeys.lat)
        let lon = UserDefaults.standard.double(forKey: cacheKeys.lon)
        let title = UserDefaults.standard.string(forKey: cacheKeys.title)
        
        guard lat != 0 || lon != 0 else { return }
        
        let cachedCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.location = cachedCoordinate
        
        if let title = title {
            self.locationTitle = title
        }
        
        PrayerManager.shared.calculatePrayers(at: cachedCoordinate)
        PrayerManager.shared.calculateQibla(at: cachedCoordinate)
    }
}

extension CLLocation {
    func fetchCityWithContext() async throws -> (String) {
        guard let request = MKReverseGeocodingRequest(location: self),
              let addressRepresentations = try await request.mapItems.first?.addressRepresentations else {
            throw MKError(.decodingFailed)
        }
        return (addressRepresentations.cityWithContext ?? "")
    }
}

