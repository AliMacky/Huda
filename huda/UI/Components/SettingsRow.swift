/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * SettingsRow.swift
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

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: 24)
                .foregroundStyle(Color("AccentTeal"))

            Text(title)
                .font(.body)
                .foregroundStyle(Color("PrimaryText"))
                .multilineTextAlignment(.leading)

            Spacer()

            Text(value)
                .font(.subheadline)
                .foregroundStyle(Color("SecondaryText"))

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Color("TertiaryText"))
        }
        .padding(16)
    }
}
