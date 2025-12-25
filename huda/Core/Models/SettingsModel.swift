/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * SettingsModel.swift
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

struct SettingsModel: Codable, Equatable {
    var onboardingComplete: Bool = false
    var calculationMethod: CalculationPreference = .na
    var asrMadhab: MadhabPreference = .shafi
    var selectedMosque: MosqueData? = nil
    var notificationsEnabled: Bool = true
    var prayerNotificationModes: [String: PrayerNotificationMode] = [
        "fajr": .athan,
        "dhuhr": .athan,
        "asr": .athan,
        "maghrib": .athan,
        "isha": .athan,
    ]
    var selectedAthanSound: AthanSound = .imadi
    var lastNotificationScheduleDate: Date? = nil
    var lastBackgroundRefreshDate: Date? = nil
    var locationMode: LocationMode = .automatic
    var manualLocationLatitude: Double? = nil
    var manualLocationLongitude: Double? = nil
    var manualLocationTitle: String? = nil
    var manualLocationTimezone: String? = nil
    var useAdvancedCalculation: Bool = false
    var customCalculationParameters: CustomCalculationParameters =
        .init()
}
