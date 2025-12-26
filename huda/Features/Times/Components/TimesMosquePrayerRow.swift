/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * TimesMosquePrayerRow.swift
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
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(prayer.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        Color(prayer.passed ? "SecondaryText" : "PrimaryText")
                    )

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
                            .accessibilityHidden(true)
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    private var accessibilityDescription: String {
        var description = "\(prayer.name), athan at \(prayer.time), iqama at \(prayer.iqamaTime)"
        if prayer.passed {
            description += ", completed"
        }
        return description
    }
}
