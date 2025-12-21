/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * CalculationAngleRow.swift
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

struct CalculationAngleRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundStyle(Color("PrimaryText"))

            Spacer()

            Text(String(format: "%.1f°", value))
                .font(.body)
                .foregroundStyle(Color("SecondaryText"))
                .frame(width: 50, alignment: .trailing)

            Stepper(
                "",
                value: $value,
                in: range,
                step: 0.5
            )
            .labelsHidden()
        }
        .padding(16)
    }
}
