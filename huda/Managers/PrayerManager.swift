/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * PrayerManager.swift
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

import Adhan
import CoreLocation
import Foundation

@Observable
class PrayerManager {
    static let shared = PrayerManager()
    private var settingsManager = SettingsManager.shared
    private var locationManager = LocationManager.shared

    var currentPrayerTimes: PrayerTimes?
    var qiblaDirection: Double = 0.0

    private init() {}

    func calculatePrayers(at location: CLLocationCoordinate2D) {
        var params: CalculationParameters

        if settingsManager.useAdvancedCalculation {
            params = CalculationMethod.other.params
            let custom = settingsManager.customCalculationParameters
            params.fajrAngle = custom.fajrAngle
            params.ishaAngle = custom.ishaAngle
            if let interval = custom.ishaInterval {
                params.ishaInterval = interval
            }
            params.highLatitudeRule = custom.highLatitudeRule.packageValue
            params.adjustments = custom.adjustments.packageValue
        } else {
            params = settingsManager.selectedMethod.packageValue.params
        }

        params.madhab = settingsManager.selectedAsrMadhab.packageValue

        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        let coordinates = Coordinates(
            latitude: location.latitude,
            longitude: location.longitude
        )

        if let prayers = PrayerTimes(
            coordinates: coordinates,
            date: date,
            calculationParameters: params
        ) {
            self.currentPrayerTimes = prayers
        }
    }

    func calculateQibla(at location: CLLocationCoordinate2D) {
        let coordinates = Coordinates(
            latitude: location.latitude,
            longitude: location.longitude
        )
        let qibla = Qibla(coordinates: coordinates)
        self.qiblaDirection = qibla.direction
    }

    func updateCalculationMethod(to calculationMethod: CalculationPreference) {
        settingsManager.selectedMethod = calculationMethod
        if let location = locationManager.effectiveLocation {
            calculatePrayers(at: location)
        }
    }

    func updateAsrMadhab(to madhab: MadhabPreference) {
        settingsManager.selectedAsrMadhab = madhab
        if let location = locationManager.effectiveLocation {
            calculatePrayers(at: location)
        }
    }
}
