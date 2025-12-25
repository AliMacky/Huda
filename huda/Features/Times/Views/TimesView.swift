/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * TimesView.swift
 * This file is part of Huda.
 */

import _LocationEssentials
import Adhan
import SwiftUI

struct TimesView: View {
    @State private var selectedDate = Date()
    @State private var selectedView = 0

    var locationManager = LocationManager.shared
    var prayerManager = PrayerManager.shared
    var settingsManager = SettingsManager.shared
    var mosqueManager = MosqueManager.shared
    var timeManager = TimeManager.shared

    private var prayerTimesForDate: PrayerTimes? {
        guard let location = locationManager.effectiveLocation else {
            return nil
        }

        var params = settingsManager.selectedMethod.packageValue.params
        params.madhab = settingsManager.selectedAsrMadhab.packageValue

        let cal = Calendar(identifier: .gregorian)
        let date = cal.dateComponents(
            [.year, .month, .day],
            from: selectedDate
        )
        let coordinates = Coordinates(
            latitude: location.latitude,
            longitude: location.longitude
        )

        return PrayerTimes(
            coordinates: coordinates,
            date: date,
            calculationParameters: params
        )
    }

    private var prayers: [PrayerItem] {
        let prayersToShow: [Adhan.Prayer] = [
            .fajr, .dhuhr, .asr, .maghrib, .isha,
        ]

        if let times = prayerTimesForDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            formatter.timeZone = locationManager.effectiveTimezone

            return prayersToShow.map { prayer in
                let prayerTime = times.time(for: prayer)

                return PrayerItem(
                    name: prayer.localizedName,
                    time: formatter.string(from: prayerTime),
                    arabicName: arabicName(for: prayer),
                    passed: timeManager.now > prayerTime
                        && Calendar.current.isDate(
                            selectedDate,
                            inSameDayAs: Date()
                        ),
                    icon: iconForPrayer(prayer)
                )
            }
        } else {
            return prayersToShow.map { prayer in
                PrayerItem(
                    name: prayer.localizedName,
                    time: "--:--",
                    arabicName: arabicName(for: prayer),
                    passed: false,
                    icon: iconForPrayer(prayer)
                )
            }
        }
    }

    private var mosquePrayers: [MosquePrayerItem]? {
        guard !mosqueManager.prayerTimes.isEmpty else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: selectedDate)

        guard
            let daySchedule = mosqueManager.prayerTimes.first(
                where: { $0.date == dateString }
            )
        else {
            return nil
        }

        let fullFormatter = DateFormatter()
        fullFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        fullFormatter.locale = Locale(identifier: "en_US_POSIX")

        let prayerData:
            [(
                name: String,
                arabic: String,
                athan: String,
                iqama: String,
                icon: String
            )] = [
                (
                    "Fajr", "الفجر", daySchedule.athan.fajr,
                    daySchedule.iqama.fajr, "sunrise.fill"
                ),
                (
                    "Dhuhr", "الظهر", daySchedule.athan.zuhr,
                    daySchedule.iqama.zuhr, "sun.max.fill"
                ),
                (
                    "Asr", "العصر", daySchedule.athan.asr,
                    daySchedule.iqama.asr, "sun.min.fill"
                ),
                (
                    "Maghrib", "المغرب", daySchedule.athan.maghrib,
                    daySchedule.iqama.maghrib, "sunset.fill"
                ),
                (
                    "Isha", "العشاء", daySchedule.athan.isha,
                    daySchedule.iqama.isha, "moon.stars.fill"
                ),
            ]

        return prayerData.map { prayer in
            let iqamaString = "\(daySchedule.date) \(prayer.iqama)"
            let isPassed: Bool
            if Calendar.current.isDate(selectedDate, inSameDayAs: Date()),
               let iqamaDate = fullFormatter.date(from: iqamaString)
            {
                isPassed = timeManager.now > iqamaDate
            } else {
                isPassed = false
            }

            return MosquePrayerItem(
                name: prayer.name,
                time: prayer.athan,
                iqamaTime: prayer.iqama,
                arabicName: prayer.arabic,
                passed: isPassed,
                icon: prayer.icon
            )
        }
    }

    private var hijriDateString: String {
        let hijri = Calendar(identifier: .islamicUmmAlQura)
        let formatter = DateFormatter()
        formatter.calendar = hijri
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: selectedDate) + " AH"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                TimesHeaderView(selectedDate: $selectedDate)

                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 16) {
                        TimesDateLocationView(
                            selectedDate: selectedDate,
                            hijriDateString: hijriDateString,
                            locationManager: locationManager
                        )
                        TimesViewToggle(selectedView: $selectedView)
                        TimesMethodInfoView(
                            selectedView: selectedView,
                            settingsManager: settingsManager
                        )
                    }
                    .padding(20)
                    .background(Color("CardBackground"))

                    TimesPrayerList(
                        selectedView: selectedView,
                        prayers: prayers,
                        mosquePrayers: mosquePrayers,
                        settingsManager: settingsManager
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            Color("PrimaryText").opacity(0.05),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 100)
        }
        .background(Color("Background"))
        .onAppear {
            if let savedMosque = settingsManager.selectedMosque {
                Task {
                    await mosqueManager.fetchMosquePrayerTimes(
                        mosque: savedMosque
                    )
                }
            }
        }
    }

    private func iconForPrayer(_ prayer: Adhan.Prayer) -> String {
        switch prayer {
        case .fajr, .sunrise: return "sunrise.fill"
        case .dhuhr: return "sun.max.fill"
        case .asr: return "sun.min.fill"
        case .maghrib: return "sunset.fill"
        case .isha: return "moon.stars.fill"
        }
    }
}
