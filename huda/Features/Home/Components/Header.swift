/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * Header.swift
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

struct Header: View {
    let locationTitle: String?
    let isConnected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Text(locationTitle ?? "Unknown")
                        .font(.subheadline)
                        .foregroundStyle(Color("SecondaryText"))
                    if !isConnected {
                        HStack(spacing: 4) {
                            Image(systemName: "wifi.slash")
                                .font(.system(size: 10, weight: .semibold))
                                .accessibilityHidden(true)
                            Text("Offline")
                                .font(.caption2)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(Color("AccentOrange"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color("AccentOrange").opacity(0.15))
                        )
                    }
                }
                Text(
                    Date(),
                    format: .dateTime.weekday(.wide).month(.abbreviated).day()
                )
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color("PrimaryText"))
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(headerAccessibilityLabel)
            Spacer()
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
                    .font(.title2)
                    .foregroundStyle(Color("SecondaryText"))
            }
            .accessibilityLabel("Settings")
            .accessibilityHint("Opens app settings")
        }
    }

    private var headerAccessibilityLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let dateString = dateFormatter.string(from: Date())
        var label = "\(locationTitle ?? "Unknown"), \(dateString)"
        if !isConnected {
            label += ", offline mode"
        }
        return label
    }
}
