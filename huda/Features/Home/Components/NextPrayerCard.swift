/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * NextPrayerCard.swift
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

struct NextPrayerCard: View {
    let state: PrayerProgressState?
    var timeManager = TimeManager.shared
    var locationManager = LocationManager.shared

    private var formattedEndTime: String? {
        guard let endTime = state?.endTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = locationManager.effectiveTimezone
        return formatter.string(from: endTime)
    }

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

                Text(state?.name.capitalized ?? "Calculating")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))

                HStack(spacing: 8) {
                    Text(timeString)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("AccentTeal"))
                        .lineLimit(1)

                    if let endTimeStr = formattedEndTime {
                        Text("• \(endTimeStr)")
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
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("CardBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color("AccentTeal").opacity(0.3),
                                    Color.clear,
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
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
