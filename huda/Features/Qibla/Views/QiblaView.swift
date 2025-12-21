/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * QiblaView.swift
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
import _LocationEssentials

struct QiblaView: View {
    var prayerManager = PrayerManager.shared
    var locationManager = LocationManager.shared
    var relativeDirection: Double {
        return prayerManager.qiblaDirection - locationManager.heading
    }

    var body: some View {
        VStack {
            QiblaHeader()

            Spacer()

            QiblaDial(
                heading: locationManager.heading,
                relativeDirection: relativeDirection
            )

            Spacer()

            VStack(spacing: 12) {
                DirectionCard(
                    qiblaDirection: prayerManager.qiblaDirection,
                    cardinalDirection: cardinalDirection(
                        from: prayerManager.qiblaDirection
                    )
                )

                LocationCard(
                    locationTitle: locationManager.effectiveLocationTitle,
                    coordinates: locationManager.effectiveLocation
                )
            }

        }
        .padding(.horizontal, 24)
        .padding(.bottom, 100)
        .onAppear {
            locationManager.startUpdatingHeading()
        }
        .onDisappear {
            locationManager.stopUpdatingHeading()
        }
    }

    private func cardinalDirection(from degrees: Double) -> String {
        let directions = [
            "North", "North East", "East", "South East", "South", "South West",
            "West", "North West",
        ]
        let index = Int((degrees + 22.5) / 45.0) % 8
        return directions[index]
    }
}
