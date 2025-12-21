/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * CalibrationTutorialSheet.swift
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

struct CalibrationTutorialSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("Calibrate Your Compass")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color("PrimaryText"))

            Text("∞")
                .font(.system(size: 80))
                .foregroundStyle(Color("AccentTeal"))

            Text(
                "Move your phone in a figure-8 pattern until the compass is calibrated."
            )
            .font(.body)
            .foregroundStyle(Color("SecondaryText"))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)

            Button {
                dismiss()
            } label: {
                Text("Got it")
                    .font(.headline)
                    .foregroundStyle(Color("PrimaryText"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentTeal"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
        .padding(.top, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
}
