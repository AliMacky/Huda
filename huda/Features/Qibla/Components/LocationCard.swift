/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * LocationCard.swift
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

import CoreLocation
import SwiftUI

struct LocationCard: View {
    let locationTitle: String?
    let coordinates: CLLocationCoordinate2D?

    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundStyle(Color("AccentOrange"))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Your Location")
                    .font(.caption)
                    .foregroundStyle(Color("PrimaryText").opacity(0.5))

                Text(locationTitle ?? "Unknown")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color("PrimaryText"))
            }

            Spacer()

            if let location = coordinates {
                Text(
                    "\(String(format: "%.2f", location.latitude))° \(location.latitude >= 0 ? "N" : "S"), \(String(format: "%.2f", abs(location.longitude)))° \(location.longitude >= 0 ? "E" : "W")"
                )
                .font(.caption2)
                .foregroundStyle(Color("TertiaryText"))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground").opacity(0.6))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    private var accessibilityDescription: String {
        var description = "Your location: \(locationTitle ?? "Unknown")"
        if let location = coordinates {
            let latDir = location.latitude >= 0 ? "North" : "South"
            let lonDir = location.longitude >= 0 ? "East" : "West"
            description += ", coordinates: \(String(format: "%.2f", abs(location.latitude))) degrees \(latDir), \(String(format: "%.2f", abs(location.longitude))) degrees \(lonDir)"
        }
        return description
    }
}
