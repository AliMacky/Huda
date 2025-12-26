/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * NotificationSettingsRow.swift
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

struct NotificationSettingsRow: View {
    let prayerName: String
    let prayerKey: String
    var settingsManager: SettingsManager

    init(
        prayerName: String,
        prayerKey: String,
        settingsManager: SettingsManager
    ) {
        self.prayerName = prayerName
        self.prayerKey = prayerKey
        self.settingsManager = settingsManager
    }

    private var currentMode: PrayerNotificationMode {
        settingsManager.prayerNotificationModes[prayerKey] ?? .athan
    }

    var body: some View {
        HStack {
            Text(prayerName)
                .font(.body)
                .fontWeight(.medium)
                .foregroundStyle(Color("PrimaryText"))
                .frame(width: 80, alignment: .leading)

            Spacer()

            HStack(spacing: 4) {
                ForEach(PrayerNotificationMode.allCases) { mode in
                    Button(action: {
                        settingsManager.prayerNotificationModes[prayerKey] =
                            mode
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: mode.icon)
                                .font(.system(size: 16))
                                .accessibilityHidden(true)
                            Text(mode.displayName)
                                .font(.caption2)
                        }
                        .frame(width: 60, height: 50)
                        .foregroundStyle(
                            currentMode == mode
                                ? Color("PrimaryText") : Color("SecondaryText")
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    currentMode == mode
                                        ? Color("AccentTeal").opacity(0.2)
                                        : Color("CardBackground")
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    currentMode == mode
                                        ? Color("AccentTeal") : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    }
                    .accessibilityLabel("\(prayerName) \(mode.displayName)")
                    .accessibilityAddTraits(currentMode == mode ? [.isSelected] : [])
                }
            }
        }
        .padding(12)
        .background(Color("CardBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
