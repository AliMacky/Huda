/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * TimesView.swift
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

struct TimesView: View {
    @State private var selectedDate = Date()
    @State private var selectedView = 0
    
    var locationManager = LocationManager.shared
    var prayerManager = PrayerManager.shared
    var settingsManager = SettingsManager.shared
    var mosqueManager = MosqueManager.shared
    var timeManager = TimeManager.shared
    
    private var prayerTimesForDate: PrayerTimes? {
        guard let location = locationManager.location else { return nil }
        
        var params = settingsManager.selectedMethod.packageValue.params
        params.madhab = settingsManager.selectedAsrMadhab.packageValue
        
        let cal = Calendar(identifier: .gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: selectedDate)
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
            return prayersToShow.map { prayer in
                let prayerTime = times.time(for: prayer)
                
                return PrayerItem(
                    name: prayer.localizedName,
                    time: prayerTime.formatted(.dateTime.hour().minute()),
                    arabicName: arabicName(for: prayer),
                    passed: timeManager.now > prayerTime
                    && Calendar.current.isDate(selectedDate, inSameDayAs: Date()),
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
    
    private var mosquePrayers: [MosquePrayerItem]? {
        guard !mosqueManager.prayerTimes.isEmpty else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: selectedDate)
        
        guard let daySchedule = mosqueManager.prayerTimes.first(
            where: { $0.date == dateString }
        ) else {
            return nil
        }
        
        let fullFormatter = DateFormatter()
        fullFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        fullFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let prayerData: [(
            name: String,
            arabic: String,
            athan: String,
            iqama: String,
            icon: String
        )] = [
            ("Fajr", "الفجر", daySchedule.athan.fajr, daySchedule.iqama.fajr, "sunrise.fill"),
            ("Dhuhr", "الظهر", daySchedule.athan.zuhr, daySchedule.iqama.zuhr, "sun.max.fill"),
            ("Asr", "العصر", daySchedule.athan.asr, daySchedule.iqama.asr, "sun.min.fill"),
            ("Maghrib", "المغرب", daySchedule.athan.maghrib, daySchedule.iqama.maghrib, "sunset.fill"),
            ("Isha", "العشاء", daySchedule.athan.isha, daySchedule.iqama.isha, "moon.stars.fill"),
        ]
        
        return prayerData.map { prayer in
            let iqamaString = "\(daySchedule.date) \(prayer.iqama)"
            let isPassed: Bool
            if Calendar.current.isDate(selectedDate, inSameDayAs: Date()),
               let iqamaDate = fullFormatter.date(from: iqamaString) {
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
    
    private var weekDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let weekStart = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        ) else {
            return []
        }
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekStart)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Prayer Times")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color("PrimaryText"))
                            
                            Text("Salah • صلاة")
                                .font(.caption)
                                .foregroundStyle(Color("SecondaryText"))
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(weekDates, id: \.self) { date in
                            WeekDayButton(
                                date: date,
                                isSelected: Calendar.current.isDate(
                                    date,
                                    inSameDayAs: selectedDate
                                ),
                                action: { selectedDate = date }
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedDate.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))
                                    .font(.headline)
                                    .foregroundStyle(Color("PrimaryText"))
                                Text(hijriDateString)
                                    .font(.caption2)
                                    .foregroundStyle(Color("SecondaryText"))
                            }
                            
                            Spacer()
                            
                            if let location = locationManager.location {
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(locationManager.locationTitle ?? "Unknown")
                                        .font(.caption)
                                        .foregroundStyle(Color("SecondaryText"))
                                    Text(String(
                                        format: "%.2f°N, %.2f°W",
                                        location.latitude,
                                        abs(location.longitude)
                                    ))
                                    .font(.caption2)
                                    .foregroundStyle(Color("SecondaryText").opacity(0.6))
                                }
                            }
                        }
                        
                        HStack(spacing: 0) {
                            Button(action: { withAnimation { selectedView = 0 } }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "location.fill")
                                        .font(.caption)
                                    Text("My Location")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .foregroundStyle(
                                    selectedView == 0
                                    ? Color("PrimaryText")
                                    : Color("SecondaryText")
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            selectedView == 0
                                            ? Color("AccentTeal")
                                            : Color.clear
                                        )
                                )
                            }
                            
                            Button(action: { withAnimation { selectedView = 1 } }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "building.2.fill")
                                        .font(.caption)
                                    Text("Mosque")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .foregroundStyle(
                                    selectedView == 1
                                    ? Color("PrimaryText")
                                    : Color("SecondaryText")
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            selectedView == 1
                                            ? Color("AccentTeal")
                                            : Color.clear
                                        )
                                )
                            }
                        }
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("PrimaryText").opacity(0.05))
                        )
                        
                        if selectedView == 0 {
                            HStack(spacing: 6) {
                                Image(systemName: "info.circle")
                                    .font(.caption2)
                                    .foregroundStyle(Color("SecondaryText"))
                                Text(
                                    "Calculation Method • \(settingsManager.selectedMethod.displayName)"
                                )
                                .font(.caption2)
                                .foregroundStyle(Color("SecondaryText"))
                            }
                            .transition(.opacity)
                        } else {
                            VStack(alignment: .leading, spacing: 6) {
                                if let mosque = settingsManager.selectedMosque {
                                    HStack(spacing: 8) {
                                        Image(systemName: "building.2.fill")
                                            .font(.caption)
                                            .foregroundStyle(Color("AccentTeal"))
                                        
                                        Text(mosque.name)
                                            .font(.caption)
                                            .foregroundStyle(Color("AccentTeal"))
                                    }
                                }
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "info.circle")
                                        .font(.caption2)
                                        .foregroundStyle(Color("SecondaryText"))
                                    Text("Mosque times may differ slightly")
                                        .font(.caption2)
                                        .foregroundStyle(Color("SecondaryText"))
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding(20)
                    .background(Color("CardBackground"))
                    
                    if selectedView == 0 {
                        VStack(spacing: 0) {
                            ForEach(
                                Array(prayers.enumerated()),
                                id: \.element.id
                            ) { index, prayer in
                                TimesLocationPrayerRow(prayer: prayer)
                                
                                if index < prayers.count - 1 {
                                    Divider()
                                        .background(Color("PrimaryText").opacity(0.05))
                                        .padding(.leading, 60)
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .background(Color("CardBackground").opacity(0.6))
                        .transition(.opacity)
                    } else {
                        if let mosquePrayers = mosquePrayers {
                            VStack(spacing: 0) {
                                ForEach(
                                    Array(mosquePrayers.enumerated()),
                                    id: \.element.id
                                ) { index, prayer in
                                    TimesMosquePrayerRow(prayer: prayer)
                                    
                                    if index < mosquePrayers.count - 1 {
                                        Divider()
                                            .background(Color("PrimaryText").opacity(0.05))
                                            .padding(.leading, 60)
                                    }
                                }
                            }
                            .padding(.vertical, 12)
                            .background(Color("CardBackground").opacity(0.6))
                            .transition(.opacity)
                        } else if settingsManager.selectedMosque == nil {
                            VStack(spacing: 12) {
                                Image(systemName: "building.2")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color("SecondaryText"))
                                Text("No Mosque Selected")
                                    .font(.headline)
                                    .foregroundStyle(Color("PrimaryText"))
                                Text("Select a mosque in Settings to view iqama times")
                                    .font(.caption)
                                    .foregroundStyle(Color("SecondaryText"))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                            .background(Color("CardBackground").opacity(0.6))
                        } else {
                            VStack(spacing: 12) {
                                ProgressView()
                                    .tint(Color("AccentTeal"))
                                Text("Loading mosque times...")
                                    .font(.caption)
                                    .foregroundStyle(Color("SecondaryText"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                            .background(Color("CardBackground").opacity(0.6))
                        }
                    }
                    
                    if Calendar.current.isDateInToday(selectedDate) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.caption2)
                                .foregroundStyle(Color("SecondaryText").opacity(0.6))
                            
                            Text(
                                "Last updated: \(timeManager.now.formatted(date: .omitted, time: .shortened))"
                            )
                            .font(.caption2)
                            .foregroundStyle(Color("SecondaryText").opacity(0.6))
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Color("CardBackground").opacity(0.4))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("PrimaryText").opacity(0.05), lineWidth: 1)
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

struct MosquePrayerItem: Identifiable {
    let id = UUID()
    let name: String
    let time: String
    let iqamaTime: String
    let arabicName: String
    let passed: Bool
    let icon: String
}

struct TimesLocationPrayerRow: View {
    let prayer: PrayerItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        prayer.passed
                        ? Color("AccentPurple").opacity(0.15)
                        : Color("AccentOrange").opacity(0.15)
                    )
                    .frame(width: 44, height: 44)
                Image(systemName: prayer.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(
                        prayer.passed
                        ? Color("AccentPurple")
                        : Color("AccentOrange")
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(prayer.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(prayer.passed ? "SecondaryText" : "PrimaryText"))
                
                Text(prayer.arabicName)
                    .font(.caption)
                    .foregroundStyle(Color("SecondaryText"))
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                if prayer.passed {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Color("AccentPurple"))
                }
                
                Text(prayer.time)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        prayer.passed
                        ? Color("PrimaryText").opacity(0.4)
                        : Color("AccentOrange")
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct TimesMosquePrayerRow: View {
    let prayer: MosquePrayerItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        prayer.passed
                        ? Color("AccentPurple").opacity(0.15)
                        : Color("AccentOrange").opacity(0.15)
                    )
                    .frame(width: 44, height: 44)
                Image(systemName: prayer.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(
                        prayer.passed
                        ? Color("AccentPurple")
                        : Color("AccentOrange")
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(prayer.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(prayer.passed ? "SecondaryText" : "PrimaryText"))
                
                Text(prayer.arabicName)
                    .font(.caption)
                    .foregroundStyle(Color("SecondaryText"))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 8) {
                    if prayer.passed {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Color("AccentPurple"))
                    }
                    
                    Text(prayer.time)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            prayer.passed
                            ? Color("PrimaryText").opacity(0.4)
                            : Color("AccentOrange")
                        )
                }
                
                HStack(spacing: 4) {
                    Text("Iqama:")
                        .font(.caption2)
                        .foregroundStyle(Color("SecondaryText"))
                    Text(prayer.iqamaTime)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color("AccentTeal"))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct WeekDayButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var dayName: String {
        date.formatted(.dateTime.weekday(.abbreviated))
    }
    
    private var dayNumber: String {
        date.formatted(.dateTime.day())
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(dayName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(
                        isSelected
                        ? Color("PrimaryText")
                        : Color("SecondaryText")
                    )
                
                Text(dayNumber)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))
                
                if isToday {
                    Circle()
                        .fill(
                            isSelected
                            ? Color("PrimaryText")
                            : Color("AccentTeal")
                        )
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected
                        ? Color("AccentTeal")
                        : Color("CardBackground")
                    )
            )
        }
    }
}

#Preview {
    TimesView()
}
