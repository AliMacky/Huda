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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(CalculationPreference.allCases) { method in
                            Button(action: {
                                settingsManager.selectedMethod = method
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(method.displayName)
                                            .font(.body)
                                            .foregroundStyle(
                                                Color("PrimaryText")
                                            )
                                    }

                                    Spacer()

                                    if settingsManager.selectedMethod == method
                                    {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(Color.accentColor)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .padding(16)
                                .background(Color("CardBackground"))
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            if method != CalculationPreference.allCases.last {
                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }
                    .background(Color("CardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    Text(
                        "The calculation method determines the angles used for Fajr and Isha, and may affect other prayer times depending on the region."
                    )
                    .font(.footnote)
                    .foregroundStyle(Color("SecondaryText"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Calculation Method")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CalculationMethodSettingsView()
    }
}
