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

struct PrayerProgressState {
    let name: String
    let icon: String
    let startTime: Date
    let endTime: Date
}

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
    
    private var nextMosqueIqama: MosqueIqamaState? {
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
                Header(locationTitle: locationManager.locationTitle)
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

struct Header: View {
    let locationTitle: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(locationTitle ?? "Unknown")
                    .font(.subheadline)
                    .foregroundStyle(Color("SecondaryText"))
                Text(
                    Date(),
                    format: .dateTime.weekday(.wide).month(.abbreviated).day()
                )
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color("PrimaryText"))
            }
            Spacer()
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
                    .font(.title2)
                    .foregroundStyle(Color("SecondaryText"))
            }
        }
    }
}

struct NextPrayerCard: View {
    let state: PrayerProgressState?
    var timeManager = TimeManager.shared
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color("PrimaryText").opacity(0.1), lineWidth: 6)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color("AccentTeal"),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                Image(systemName: state?.icon ?? "moon.stars.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Color("AccentTeal"))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("NEXT PRAYER")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("SecondaryText"))
                    .tracking(1.2)
                
                Text(state?.name ?? "Calculating")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))
                
                HStack(spacing: 8) {
                    Text(timeString)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("AccentTeal"))
                        .lineLimit(1)
                    
                    if let endTime = state?.endTime {
                        Text("• \(endTime.formatted(date: .omitted, time: .shortened))")
                            .font(.subheadline)
                            .foregroundStyle(Color("SecondaryText"))
                            .lineLimit(1)
                    }
                }
                .minimumScaleFactor(0.8)
            }
            Spacer()
        }
        .padding(20)
        .background(
            CardStyle()
        )
    }
    
    private var timeString: String {
        guard let endTime = state?.endTime else { return "Calculating" }
        let interval = endTime.timeIntervalSince(timeManager.now)
        
        guard interval > 0 else { return "Now" }
        
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
    
    private var progress: Double {
        guard let start = state?.startTime,
              let end = state?.endTime
        else { return 0.0 }
        
        let totalDuration = end.timeIntervalSince(start)
        let timeElapsed = timeManager.now.timeIntervalSince(start)
        
        guard totalDuration > 0 else { return 0.0 }
        return min(1.0, max(0.0, timeElapsed / totalDuration))
    }
}

struct PrayersCard: View {
    let prayers: [PrayerItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY'S PRAYERS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("PrimaryText").opacity(0.7))
                        .tracking(1.2)
                    
                    Text("5 Prayers")
                        .font(.subheadline)
                        .foregroundStyle(Color("PrimaryText").opacity(0.5))
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        let isPassed =
                        index < prayers.count && prayers[index].passed
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                isPassed
                                ? Color("AccentPurple")
                                : Color("PrimaryText").opacity(0.2)
                            )
                            .frame(width: 8, height: 16)
                    }
                }
            }
            .padding(20)
            .background(
                Color("CardBackground")
            )
            
            VStack(spacing: 0) {
                ForEach(Array(prayers.enumerated()), id: \.element.id) {
                    index,
                    prayer in
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
                                .foregroundStyle(Color(prayer.passed ? "SecondaryText": "PrimaryText"))
                            
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
                    
                    if index < prayers.count - 1 {
                        Divider()
                            .background(Color("PrimaryText").opacity(0.05))
                            .padding(.leading, 60)
                    }
                }
            }
            .padding(.vertical, 12)
            .background(Color("CardBackground").opacity(0.6))
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("PrimaryText").opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
    }
}

struct MosqueIqamaCard: View {
    let mosqueDetails: MosqueData
    let nextPrayerName: String?
    let nextIqamaTime: String?
    let timeUntilIqama: String?
    let minutesAfterAdhan: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("MOSQUE IQAMA")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("PrimaryText").opacity(0.5))
                        .tracking(1.5)
                    
                    Text(mosqueDetails.name)
                        .font(.subheadline)
                        .foregroundStyle(Color("PrimaryText").opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "location.fill")
                    .foregroundStyle(Color("AccentTeal"))
            }
            
            Divider()
                .background(Color("PrimaryText").opacity(0.1))
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(nextPrayerName ?? "Next") Iqama")
                        .font(.subheadline)
                        .foregroundStyle(Color("PrimaryText").opacity(0.7))
                    
                    Text(nextIqamaTime ?? "--:--")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("AccentOrange"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if let timeUntil = timeUntilIqama {
                        Text(timeUntil)
                            .font(.caption)
                            .foregroundStyle(Color("AccentTeal"))
                    }
                    
                    if let minutes = minutesAfterAdhan {
                        Text("(\(minutes) min after adhan)")
                            .font(.caption2)
                            .foregroundStyle(Color("PrimaryText").opacity(0.5))
                    }
                }
                .padding(.bottom, 2)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color("CardBackground"))
        )
    }
}

struct CardStyle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("CardBackground"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color("AccentTeal").opacity(0.3), Color.clear,
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

#Preview {
    HomeView()
}
