/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * HomeView.swift
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
import SwiftUI
import _LocationEssentials

struct HomeView: View {
    private var locationManager = LocationManager.shared
    private var prayerManager = PrayerManager.shared
    private var settingsManager = SettingsManager.shared
    private var mosqueManager = MosqueManager.shared
    private var timeManager = TimeManager.shared

    private var prayers: [PrayerItem] {
        let prayersToShow: [Adhan.Prayer] = [
            .fajr, .dhuhr, .asr, .maghrib, .isha,
        ]

        if let times = prayerManager.currentPrayerTimes {
            return prayersToShow.map { prayer in
                let prayerTime = times.time(for: prayer)

                return PrayerItem(
                    name: prayer.localizedName,
                    time: prayerTime.formatted(.dateTime.hour().minute()),
                    arabicName: arabicName(for: prayer),
                    passed: timeManager.now > prayerTime,
                    icon: iconForPrayer(prayer)
                )
            }
        } else {
            return prayersToShow.map { prayer in
                return PrayerItem(
                    name: prayer.localizedName,
                    time: "--:--",
                    arabicName: arabicName(for: prayer),
                    passed: false,
                    icon: iconForPrayer(prayer)
                )
            }
        }
    }

    private var nextMosqueIqama: MosquePrayerTimes.IqamaState? {
        return mosqueManager.getNextIqama(for: timeManager.now)
    }

    private var prayerState: PrayerProgressState? {
        guard let times = prayerManager.currentPrayerTimes else { return nil }

        if let next = times.nextPrayer() {
            let endTime = times.time(for: next)
            let startTime: Date

            if let current = times.currentPrayer() {
                startTime = times.time(for: current)
            } else {
                startTime = times.time(for: .isha).addingTimeInterval(-86400)
            }

            return PrayerProgressState(
                name: next.localizedName,
                icon: iconForPrayer(next),
                startTime: startTime,
                endTime: endTime
            )
        }

        let calendar = Calendar.current
        if let tomorrowDate = calendar.date(
            byAdding: .day,
            value: 1,
            to: Date()
        ) {
            let tomorrowComponents = calendar.dateComponents(
                [.year, .month, .day],
                from: tomorrowDate
            )
            if let tomorrowTimes = PrayerTimes(
                coordinates: times.coordinates,
                date: tomorrowComponents,
                calculationParameters: times.calculationParameters
            ) {
                return PrayerProgressState(
                    name: Prayer.fajr.localizedName,
                    icon: iconForPrayer(.fajr),
                    startTime: times.isha,
                    endTime: tomorrowTimes.fajr
                )
            }
        }

        return nil
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Header(
                    locationTitle: locationManager.locationTitle,
                    isConnected: NetworkMonitor.shared.isConnected
                )
                NextPrayerCard(state: prayerState)
                PrayersCard(prayers: prayers)
                if let details = settingsManager.selectedMosque {
                    if let iqamaState = nextMosqueIqama {
                        MosqueIqamaCard(
                            mosqueDetails: details,
                            nextPrayerName: iqamaState.prayerName,
                            nextIqamaTime: iqamaState.iqamaTime,
                            timeUntilIqama: iqamaState.timeUntil,
                            minutesAfterAdhan: iqamaState.minutesAfterAdhan
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            .padding(.bottom, 100)
            .onAppear {
                locationManager.requestPermission()
                if let savedMosque = settingsManager.selectedMosque {
                    Task {
                        await mosqueManager.fetchMosquePrayerTimes(
                            mosque: savedMosque
                        )
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func iconForPrayer(_ prayer: Prayer) -> String {
        switch prayer {
        case .fajr, .sunrise: return "sunrise.fill"
        case .dhuhr: return "sun.max.fill"
        case .asr: return "sun.min.fill"
        case .maghrib: return "sunset.fill"
        case .isha: return "moon.stars.fill"
        }
    }
}
