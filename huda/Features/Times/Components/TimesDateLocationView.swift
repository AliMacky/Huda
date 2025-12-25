/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * TimesDateLocationView.swift
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

struct TimesDateLocationView: View {
    let selectedDate: Date
    let hijriDateString: String
    var locationManager: LocationManager

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(
                    selectedDate.formatted(
                        .dateTime.weekday(.wide).month(.abbreviated).day()
                    )
                )
                .font(.headline)
                .foregroundStyle(Color("PrimaryText"))
                Text(hijriDateString)
                    .font(.caption2)
                    .foregroundStyle(Color("SecondaryText"))
            }

            Spacer()

            if let location = locationManager.effectiveLocation {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(locationManager.effectiveLocationTitle ?? "Unknown")
                        .font(.caption)
                        .foregroundStyle(Color("SecondaryText"))
                    Text(
                        String(
                            format: "%.2f°N, %.2f°W",
                            location.latitude,
                            abs(location.longitude)
                        )
                    )
                    .font(.caption2)
                    .foregroundStyle(Color("SecondaryText").opacity(0.6))
                }
            }
        }
    }
}
