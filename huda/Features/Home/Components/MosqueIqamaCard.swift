/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * MosqueIqamaCard.swift
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

import SwiftUI

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
                    .accessibilityHidden(true)
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    private var accessibilityDescription: String {
        var description = "Mosque iqama at \(mosqueDetails.name)."
        if let prayer = nextPrayerName, let time = nextIqamaTime {
            description += " \(prayer) iqama at \(time)"
        }
        if let timeUntil = timeUntilIqama {
            description += ", \(timeUntil)"
        }
        return description
    }
}
