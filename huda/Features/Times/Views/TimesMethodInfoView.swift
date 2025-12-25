/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * TimesMethodInfoView.swift
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

struct TimesMethodInfoView: View {
    let selectedView: Int
    var settingsManager: SettingsManager

    var body: some View {
        if selectedView == 0 {
            HStack(spacing: 6) {
                Image(systemName: "info.circle")
                    .font(.caption2)
                    .foregroundStyle(Color("SecondaryText"))
                Text(
                    "Calculation Method • \(settingsManager.selectedMethod.displayName)"
                )
                .font(.caption2)
                .foregroundStyle(Color("SecondaryText"))
            }
            .transition(.opacity)
        } else {
            VStack(alignment: .leading, spacing: 6) {
                if let mosque = settingsManager.selectedMosque {
                    HStack(spacing: 8) {
                        Image(systemName: "building.2.fill")
                            .font(.caption)
                            .foregroundStyle(Color("AccentTeal"))

                        Text(mosque.name)
                            .font(.caption)
                            .foregroundStyle(Color("AccentTeal"))
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .font(.caption2)
                        .foregroundStyle(Color("SecondaryText"))
                    Text("Mosque times may differ slightly")
                        .font(.caption2)
                        .foregroundStyle(Color("SecondaryText"))
                }
            }
            .transition(.opacity)
        }
    }
}
