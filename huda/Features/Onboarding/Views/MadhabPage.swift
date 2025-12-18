/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * MadhabPage.swift
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

struct MadhabPage: View {
    @Binding var selectedMadhab: MadhabPreference
    let onNext: () -> Void
    @Binding var currentPage: Int

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text("Asr Calculation")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))

                Text("Select your preferred method for Asr time")
                    .font(.subheadline)
                    .foregroundStyle(Color("SecondaryText"))

                Text("وقت صلاة العصر")
                    .font(.caption)
                    .foregroundStyle(Color("TertiaryText"))
            }
            .padding(.top, 100)

            VStack(spacing: 12) {
                ForEach(MadhabPreference.allCases) { preference in
                    MethodCard(
                        title: preference.displayName,
                        subtitle: preference == .shafi
                            ? "Standard (Earlier)" : "Hanafi (Later)",
                        isSelected: selectedMadhab == preference,
                        onTap: { selectedMadhab = preference }
                    )
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 12) {
                Button(action: onNext) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundStyle(Color("PrimaryText"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("AccentTeal"))
                        )
                }

                Button(action: { currentPage -= 1 }) {
                    Text("Back")
                        .font(.subheadline)
                        .foregroundStyle(Color("SecondaryText"))
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}
