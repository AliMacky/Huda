/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * SettingsManager.swift
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
import Adhan
import Observation

@Observable
class SettingsManager {
    static let shared = SettingsManager()
    
    var onboardingComplete: Bool = UserDefaults.standard.bool(forKey: "onboarded") {
        didSet {
            UserDefaults.standard.set(onboardingComplete, forKey: "onboarded")
        }
    }
    
    var selectedMethod: CalculationPreference = {
        if let raw = UserDefaults.standard.string(forKey: "calc_method"),
           let method = CalculationPreference(rawValue: raw) {
            return method
        }
        return .na
    }() {
        didSet {
            UserDefaults.standard.set(selectedMethod.rawValue, forKey: "calc_method")
        }
    }
    
    var selectedAsrMadhab: MadhabPreference = {
        if let raw = UserDefaults.standard.string(forKey: "madhab_pref"),
           let method = MadhabPreference(rawValue: raw) {
            return method
        }
        return .shafi
    }() {
        didSet {
            UserDefaults.standard.set(selectedAsrMadhab.rawValue, forKey: "madhab_pref")
        }
    }
    
    var selectedMosque: MosqueData? = {
        guard let data = UserDefaults.standard.data(forKey: "user_mosque") else { return nil }
        if let decoded = try? JSONDecoder().decode(MosqueData.self, from: data) {
            return decoded
        }
        return nil
    }() {
        didSet {
            if let newValue = selectedMosque {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: "user_mosque")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "user_mosque")
            }
        }
    }
        
    var notificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "notifications_enabled") {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notifications_enabled")
        }
    }
    
    var enabledPrayers: Set<Prayer> = {
        if let raw = UserDefaults.standard.array(forKey: "enabled_prayers") as? [String] {
            return Set(raw.compactMap { Prayer.from(localizedName: $0) })
        }
        return [.fajr, .dhuhr, .asr, .maghrib, .isha]
    }() {
        didSet {
            let raw = enabledPrayers.map { $0.localizedName }
            UserDefaults.standard.set(raw, forKey: "enabled_prayers")
        }
    }
    
    var lastNotificationScheduleDate: Date? = UserDefaults.standard.object(forKey: "last_notification_schedule") as? Date {
        didSet {
            UserDefaults.standard.set(lastNotificationScheduleDate, forKey: "last_notification_schedule")
        }
    }
    
    var lastBackgroundRefreshDate: Date? = UserDefaults.standard.object(forKey: "last_background_refresh") as? Date {
        didSet {
            UserDefaults.standard.set(lastBackgroundRefreshDate, forKey: "last_background_refresh")
        }
    }
    
    private init() {}
}
