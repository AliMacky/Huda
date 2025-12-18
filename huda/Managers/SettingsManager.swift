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

import Adhan
import Foundation
import Observation

@Observable
class SettingsManager {
    static let shared = SettingsManager()

    var settings: SettingsModel {
        didSet {
            save()
        }
    }

    private init() {
        self.settings = SettingsManager.load()
    }

    var onboardingComplete: Bool {
        get { settings.onboardingComplete }
        set { settings.onboardingComplete = newValue }
    }

    var selectedMethod: CalculationPreference {
        get { settings.calculationMethod }
        set {
            settings.calculationMethod = newValue
            Task {
                await NotificationManager.shared.scheduleAllNotifications()
            }
        }
    }

    var selectedAsrMadhab: MadhabPreference {
        get { settings.asrMadhab }
        set {
            settings.asrMadhab = newValue
            Task {
                await NotificationManager.shared.scheduleAllNotifications()
            }
        }
    }

    var selectedMosque: MosqueData? {
        get { settings.selectedMosque }
        set { settings.selectedMosque = newValue }
    }

    var notificationsEnabled: Bool {
        get { settings.notificationsEnabled }
        set {
            settings.notificationsEnabled = newValue
            Task {
                await NotificationManager.shared.scheduleAllNotifications()
            }
        }
    }

    var prayerNotificationModes: [String: PrayerNotificationMode] {
        get { settings.prayerNotificationModes }
        set {
            settings.prayerNotificationModes = newValue
            Task {
                await NotificationManager.shared.scheduleAllNotifications()
            }
        }
    }

    var selectedAthanSound: AthanSound {
        get { settings.selectedAthanSound }
        set {
            settings.selectedAthanSound = newValue
            Task {
                await NotificationManager.shared.scheduleAllNotifications()
            }
        }
    }

    var lastNotificationScheduleDate: Date? {
        get { settings.lastNotificationScheduleDate }
        set { settings.lastNotificationScheduleDate = newValue }
    }

    var lastBackgroundRefreshDate: Date? {
        get { settings.lastBackgroundRefreshDate }
        set { settings.lastBackgroundRefreshDate = newValue }
    }

    func notificationMode(for prayer: Prayer) -> PrayerNotificationMode {
        let key = prayer.localizedName
        return settings.prayerNotificationModes[key] ?? .athan
    }

    func setNotificationMode(_ mode: PrayerNotificationMode, for prayer: Prayer)
    {
        let key = prayer.localizedName
        settings.prayerNotificationModes[key] = mode
        Task {
            await NotificationManager.shared.scheduleAllNotifications()
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "app_settings")
        }
    }

    private static func load() -> SettingsModel {
        if let data = UserDefaults.standard.data(forKey: "app_settings"),
            let decoded = try? JSONDecoder().decode(
                SettingsModel.self,
                from: data
            )
        {
            return decoded
        }
        return SettingsModel()
    }
}
