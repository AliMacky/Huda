/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * DirectionCard.swift
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

struct DirectionCard: View {
    let qiblaDirection: Double
    let cardinalDirection: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("DIRECTION")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("PrimaryText").opacity(0.5))
                    .tracking(1.2)

                HStack(spacing: 8) {
                    Text("\(Int(qiblaDirection))°")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("AccentTeal"))

                    Text(cardinalDirection)
                        .font(.subheadline)
                        .foregroundStyle(Color("SecondaryText"))
                }
            }

            Spacer()

            Image(systemName: "safari")
                .font(.system(size: 32))
                .foregroundStyle(Color("AccentTeal").opacity(0.3))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
        )
    }
}
