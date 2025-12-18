/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * WelcomePage.swift
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

struct WelcomePage: View {
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 24) {
                Image(systemName: "moon.stars.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color("AccentTeal"))

                VStack(spacing: 12) {
                    Text("Welcome to Huda")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PrimaryText"))

                    Text("Your companion for prayer times")
                        .font(.title3)
                        .foregroundStyle(Color("SecondaryText"))

                    Text("هدى • Guidance")
                        .font(.subheadline)
                        .foregroundStyle(Color("TertiaryText"))
                }
            }

            Spacer()

            VStack(spacing: 16) {
                Button(action: onNext) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundStyle(Color("PrimaryText"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("AccentTeal"))
                        )
                }

                Text("Let's set up your prayer times in a few steps")
                    .font(.caption)
                    .foregroundStyle(Color("TertiaryText"))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}
