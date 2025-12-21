/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * OnboardingView.swift
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

import AVFoundation
import Adhan
import SwiftUI
import _LocationEssentials

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var selectedPreference: CalculationPreference = .na
    @State private var selectedMadhab: MadhabPreference = .shafi
    @State private var tempSelectedMosque: MosqueData?

    private var settingsManager = SettingsManager.shared
    private var locationManager = LocationManager.shared
    private var prayerManager = PrayerManager.shared
    private var notificationManager = NotificationManager.shared

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    WelcomePage(onNext: { currentPage = 1 })
                        .tag(0)

                    LocationPage(onNext: {
                        currentPage = 2
                    })
                    .tag(1)

                    CalculationMethodPage(
                        selectedPreference: $selectedPreference,
                        onNext: { currentPage = 3 },
                        currentPage: $currentPage
                    )
                    .tag(2)

                    MadhabPage(
                        selectedMadhab: $selectedMadhab,
                        onNext: { currentPage = 4 },
                        currentPage: $currentPage
                    )
                    .tag(3)

                    NotificationPage(
                        onNext: {
                            let granted =
                                await notificationManager.requestPermission()
                            if granted {
                                settingsManager.notificationsEnabled = true
                                await notificationManager
                                    .scheduleAllNotifications()
                            }
                            currentPage = 5
                        },
                        currentPage: $currentPage
                    )
                    .tag(4)

                    MosquePage(
                        selectedMosque: $tempSelectedMosque,
                        onComplete: {
                            saveSettings()
                        },
                        currentPage: $currentPage
                    )
                    .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(.page(backgroundDisplayMode: .never))
            }
        }
    }

    func saveSettings() {
        prayerManager.updateCalculationMethod(to: selectedPreference)
        prayerManager.updateAsrMadhab(to: selectedMadhab)
        settingsManager.selectedMosque = tempSelectedMosque
        settingsManager.onboardingComplete = true
    }
}
