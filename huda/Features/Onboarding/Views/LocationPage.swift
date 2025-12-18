/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * LocationPage.swift
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

struct LocationPage: View {
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 32) {
                ZStack {
                    Circle()
                        .fill(Color("AccentTeal").opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Color("AccentTeal"))
                }

                VStack(spacing: 16) {
                    Text("Enable Location")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PrimaryText"))

                    VStack(spacing: 12) {
                        InfoRow(
                            icon: "clock.fill",
                            text:
                                "Calculate accurate prayer times for your location"
                        )

                        InfoRow(
                            icon: "safari.fill",
                            text: "Find the Qibla direction wherever you are"
                        )

                        InfoRow(
                            icon: "building.2.fill",
                            text: "Discover nearby mosques"
                        )
                    }
                    .padding(.horizontal, 32)
                }
            }

            Spacer()

            VStack(spacing: 12) {
                Button(action: onNext) {
                    Text("Allow Location Access")
                        .font(.headline)
                        .foregroundStyle(Color("PrimaryText"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("AccentTeal"))
                        )
                }

                Text("Your location is only used locally on your device")
                    .font(.caption)
                    .foregroundStyle(Color("TertiaryText"))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}
