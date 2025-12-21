/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * CalculationMethodSettingsView.swift
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

struct CalculationMethodSettingsView: View {
    @State private var settingsManager = SettingsManager.shared
    @State private var showAdvancedSettings = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    CalculationMethodSelector(
                        selectedMethod: $settingsManager.selectedMethod,
                        useAdvancedCalculation: $settingsManager
                            .useAdvancedCalculation,
                        customParameters: settingsManager
                            .customCalculationParameters,
                        onAdvancedTap: { showAdvancedSettings = true }
                    )

                    AsrMadhabSelector(
                        selectedMadhab: $settingsManager.selectedAsrMadhab
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Prayer Calculation")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showAdvancedSettings) {
            AdvancedCalculationSettingsView()
        }
    }
}

#Preview {
    NavigationStack {
        CalculationMethodSettingsView()
    }
}
