/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * hudaApp.swift
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

import BackgroundTasks
import SwiftUI

@main
struct hudaApp: App {
    private var settingsManager = SettingsManager.shared
    private var locationManager = LocationManager.shared
    private var prayerManager = PrayerManager.shared
    private var notificationManager = NotificationManager.shared

    private let backgroundTaskIdentifier =
        "com.alimacky.huda.refreshNotifications"

    private var isReady: Bool {
        locationManager.location != nil
            && prayerManager.currentPrayerTimes != nil
    }

    init() {
        registerBackgroundTask()
    }

    var body: some Scene {
        WindowGroup {
            if settingsManager.onboardingComplete {
                if isReady {
                    ContentView()
                } else {
                    LoadingView()
                }
            } else {
                OnboardingView()
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                scheduleBackgroundTask()
            } else if newPhase == .active
                && settingsManager.notificationsEnabled
            {
                Task {
                    await notificationManager.scheduleAllNotifications()
                }
            }
        }
    }

    @Environment(\.scenePhase) private var scenePhase

    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: backgroundTaskIdentifier,
            using: nil
        ) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    private func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(
            identifier: backgroundTaskIdentifier
        )
        request.earliestBeginDate = Date(timeIntervalSinceNow: 12 * 60 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("BGTask Error: \(error)")
        }
    }

    private func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleBackgroundTask()

        let refreshTask = Task {
            await notificationManager.refreshNotificationQueue()
        }

        task.expirationHandler = {
            refreshTask.cancel()
        }

        Task {
            await refreshTask.value
            settingsManager.lastBackgroundRefreshDate = Date()
            task.setTaskCompleted(success: true)
        }
    }
}
