/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * TimesPrayerList.swift
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

import Adhan
import SwiftUI

struct TimesPrayerList: View {
    let selectedView: Int
    let prayers: [PrayerItem]
    let mosquePrayers: [MosquePrayerItem]?
    let jummahTimes: (jummah1: String?, jummah2: String?)?
    var settingsManager: SettingsManager

    var body: some View {
        if selectedView == 0 {
            VStack(spacing: 0) {
                ForEach(Array(prayers.enumerated()), id: \.element.id) {
                    index, prayer in
                    TimesLocationPrayerRow(prayer: prayer)

                    if index < prayers.count - 1 {
                        Divider()
                            .background(Color("PrimaryText").opacity(0.05))
                            .padding(.leading, 60)
                    }
                }
            }
            .padding(.vertical, 12)
            .background(Color("CardBackground").opacity(0.6))
            .transition(.opacity)
        } else {
            if let mosquePrayers = mosquePrayers {
                VStack(spacing: 0) {
                    ForEach(
                        Array(mosquePrayers.enumerated()),
                        id: \.element.id
                    ) { index, prayer in
                        TimesMosquePrayerRow(prayer: prayer)

                        if index < mosquePrayers.count - 1 {
                            Divider()
                                .background(Color("PrimaryText").opacity(0.05))
                                .padding(.leading, 60)
                        }
                    }

                    if let jummah = jummahTimes,
                       jummah.jummah1 != nil || jummah.jummah2 != nil
                    {
                        Divider()
                            .background(Color("PrimaryText").opacity(0.05))

                        HStack(spacing: 0) {
                            if let j1 = jummah.jummah1 {
                                VStack(spacing: 2) {
                                    Text(j1)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color("AccentTeal"))
                                    Text("Jumu'ah 1")
                                        .font(.caption2)
                                        .foregroundStyle(Color("SecondaryText"))
                                }
                                .frame(maxWidth: .infinity)
                            }

                            if jummah.jummah1 != nil && jummah.jummah2 != nil {
                                Divider()
                                    .frame(height: 30)
                            }

                            if let j2 = jummah.jummah2 {
                                VStack(spacing: 2) {
                                    Text(j2)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color("AccentTeal"))
                                    Text("Jumu'ah 2")
                                        .font(.caption2)
                                        .foregroundStyle(Color("SecondaryText"))
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 12)
                    }
                }
                .padding(.vertical, 12)
                .background(Color("CardBackground").opacity(0.6))
                .transition(.opacity)
            } else if settingsManager.selectedMosque == nil {
                VStack(spacing: 12) {
                    Image(systemName: "building.2")
                        .font(.largeTitle)
                        .foregroundStyle(Color("SecondaryText"))
                    Text("No Mosque Selected")
                        .font(.headline)
                        .foregroundStyle(Color("PrimaryText"))
                    Text("Select a mosque in Settings to view iqama times")
                        .font(.caption)
                        .foregroundStyle(Color("SecondaryText"))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .background(Color("CardBackground").opacity(0.6))
            } else {
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(Color("AccentTeal"))
                    Text("Loading mosque times...")
                        .font(.caption)
                        .foregroundStyle(Color("SecondaryText"))
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .background(Color("CardBackground").opacity(0.6))
            }
        }
    }
}
