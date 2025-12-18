/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * NotificationManager.swift
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
import UserNotifications
import CoreLocation
import Adhan

@Observable
class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let settingsManager = SettingsManager.shared
    private let locationManager = LocationManager.shared
    
    private var daysToSchedule: Int {
        60 / 5
    }
    
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private init() {
        Task {
            await checkAuthorizationStatus()
        }
    }
    
    @MainActor
    func checkAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }
    
    @MainActor
    func requestPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            await checkAuthorizationStatus()
            return granted
        } catch {
            return false
        }
    }
    
    /// Schedules prayer notifications for the next 12 days
    func scheduleAllNotifications() async {
        guard settingsManager.notificationsEnabled else {
            await cancelAllNotifications()
            return
        }
        
        guard let location = locationManager.location else {
            return
        }
        
        await cancelAllNotifications()
        
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        
        for dayOffset in 0..<daysToSchedule {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            await schedulePrayersForDay(date: date, location: location)
        }
        
        settingsManager.lastNotificationScheduleDate = today
    }
    
    private func schedulePrayersForDay(date: Date, location: CLLocationCoordinate2D) async {
        var params = settingsManager.selectedMethod.packageValue.params
        params.madhab = settingsManager.selectedAsrMadhab.packageValue
        
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let coordinates = Coordinates(latitude: location.latitude, longitude: location.longitude)
        
        guard let prayerTimes = PrayerTimes(coordinates: coordinates, date: dateComponents, calculationParameters: params) else {
            return
        }
        
        let prayers: [(Prayer, Date)] = [
            (.fajr, prayerTimes.fajr),
            (.dhuhr, prayerTimes.dhuhr),
            (.asr, prayerTimes.asr),
            (.maghrib, prayerTimes.maghrib),
            (.isha, prayerTimes.isha)
        ]
        
        for (prayer, time) in prayers {
            let mode = settingsManager.notificationMode(for: prayer)
            
            guard mode != .off else { continue }
            guard time > Date() else { continue }
            
            await schedulePrayerNotification(prayer: prayer, time: time, mode: mode)
        }
    }
    
    private func schedulePrayerNotification(prayer: Prayer, time: Date, mode: PrayerNotificationMode) async {
        let content = UNMutableNotificationContent()
        content.title = "Prayer Time"
        content.body = "It's time for \(prayer.localizedName) prayer"
        content.interruptionLevel = .timeSensitive
        
        switch mode {
        case .off:
            return
        case .silent:
            content.sound = nil
        case .athan:
            let soundFile = settingsManager.selectedAthanSound.fileName
            content.sound = UNNotificationSound(named: UNNotificationSoundName(soundFile))
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let identifier = notificationIdentifier(for: prayer, on: time)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        do {
            try await notificationCenter.add(request)
        } catch {
            print("Notification Error: \(error)")
        }
    }
    
    private func notificationIdentifier(for prayer: Prayer, on date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "huda_\(prayer)_\(formatter.string(from: date))"
    }

    func cancelAllNotifications() async {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func refreshNotificationQueue() async {
        await scheduleAllNotifications()
    }

    func sendTestNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "Notifications are working"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("takber-alkatamy.caf"))
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "huda_test", content: content, trigger: trigger)
        
        do {
            try await notificationCenter.add(request)
        } catch {
            print("Notification Error: \(error)")
        }
    }
    
    func getPendingNotificationCount() async -> Int {
        let pending = await notificationCenter.pendingNotificationRequests()
        return pending.count
    }
}
