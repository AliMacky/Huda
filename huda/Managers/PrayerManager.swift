//
//  PrayerManager.swift
//  huda
//
//  Created by Ali Macky on 11/30/25.
//

import Foundation
import CoreLocation
import Adhan

@Observable
class PrayerManager {
    static let shared = PrayerManager()
    private var settingsManager = SettingsManager.shared
    private var locationManager = LocationManager.shared
    
    var currentPrayerTimes: PrayerTimes?
    var qiblaDirection: Double = 0.0
    
    private init() {}
    
    func calculatePrayers(at location: CLLocationCoordinate2D) {
        var params = settingsManager.selectedMethod.params
        params.madhab = settingsManager.selectedAsrMadhab.packageValue
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        let coordinates = Coordinates(latitude: location.latitude, longitude: location.longitude)
        
        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
            self.currentPrayerTimes = prayers
        }
    }
    
    func calculateQibla(at location: CLLocationCoordinate2D) {
        let coordinates = Coordinates(latitude: location.latitude, longitude: location.longitude)
        let qibla = Qibla(coordinates: coordinates)
        self.qiblaDirection = qibla.direction
    }
    
    func updateCalculationMethod(to calculationMethod: CalculationMethod) {
        settingsManager.selectedMethod = calculationMethod
        if let location = locationManager.location {
            calculatePrayers(at: location)
        }
    }
    
    func updateAsrMadhab(to madhab: MadhabPreference) {
        settingsManager.selectedAsrMadhab = madhab
        if let location = locationManager.location {
            calculatePrayers(at: location)
        }
    }
}
