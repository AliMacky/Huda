/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * PrayersCard.swift
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
                            Text(prayer.name.capitalized)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    Color(
                                        prayer.passed
                                            ? "SecondaryText" : "PrimaryText"
                                    )
                                )

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
