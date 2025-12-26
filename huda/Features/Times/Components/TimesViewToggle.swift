/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * TimesViewToggle.swift
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

struct TimesViewToggle: View {
    @Binding var selectedView: Int

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation { selectedView = 0 }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .accessibilityHidden(true)
                    Text("My Location")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundStyle(
                    selectedView == 0
                        ? Color("PrimaryText")
                        : Color("SecondaryText")
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            selectedView == 0
                                ? Color("AccentTeal")
                                : Color.clear
                        )
                )
            }
            .accessibilityLabel("My Location")
            .accessibilityHint("Shows prayer times for your current location")
            .accessibilityAddTraits(selectedView == 0 ? [.isSelected] : [])

            Button(action: {
                withAnimation { selectedView = 1 }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "building.2.fill")
                        .font(.caption)
                        .accessibilityHidden(true)
                    Text("Mosque")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundStyle(
                    selectedView == 1
                        ? Color("PrimaryText")
                        : Color("SecondaryText")
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            selectedView == 1
                                ? Color("AccentTeal")
                                : Color.clear
                        )
                )
            }
            .accessibilityLabel("Mosque")
            .accessibilityHint("Shows prayer times for your selected mosque")
            .accessibilityAddTraits(selectedView == 1 ? [.isSelected] : [])
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("PrimaryText").opacity(0.05))
        )
    }
}
