/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * CalculationMethodPage.swift
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

struct CalculationMethodPage: View {
    @Binding var selectedPreference: CalculationPreference
    @Binding var selectedMadhab: MadhabPreference
    @Binding var useAdvancedCalculation: Bool
    let onNext: () -> Void
    @Binding var currentPage: Int

    @State private var settingsManager = SettingsManager.shared
    @State private var showAdvancedSettings = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Prayer Calculation")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))

                Text("Choose how prayer times are calculated")
                    .font(.subheadline)
                    .foregroundStyle(Color("SecondaryText"))

                Text("حساب أوقات الصلاة")
                    .font(.caption)
                    .foregroundStyle(Color("TertiaryText"))
            }
            .padding(.top, 10)

            ScrollView {
                VStack(spacing: 24) {
                    CalculationMethodSelector(
                        selectedMethod: $selectedPreference,
                        useAdvancedCalculation: $useAdvancedCalculation,
                        customParameters: settingsManager
                            .customCalculationParameters,
                        onAdvancedTap: { showAdvancedSettings = true }
                    )

                    AsrMadhabSelector(
                        selectedMadhab: $selectedMadhab
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 140)
            }

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
            .padding(.top, 20)
            .background(
                Color("Background")
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
            )
        }
        .sheet(isPresented: $showAdvancedSettings) {
            NavigationStack {
                AdvancedCalculationSettingsView()
            }
        }
    }
}
