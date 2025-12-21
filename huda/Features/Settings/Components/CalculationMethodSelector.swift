/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * CalculationMethodSelector.swift
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

struct CalculationMethodSelector: View {
    @Binding var selectedMethod: CalculationPreference
    @Binding var useAdvancedCalculation: Bool
    let customParameters: CustomCalculationParameters
    let onAdvancedTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CALCULATION METHOD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color("SecondaryText"))

            if useAdvancedCalculation {
                Button(action: onAdvancedTap) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Custom Parameters")
                                .font(.body)
                                .foregroundStyle(Color("PrimaryText"))

                            Text(
                                "Fajr \(String(format: "%.1f", customParameters.fajrAngle))° · Isha \(String(format: "%.1f", customParameters.ishaAngle))°"
                            )
                            .font(.caption)
                            .foregroundStyle(Color("SecondaryText"))
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color("SecondaryText"))
                            .font(.caption)
                    }
                    .padding(16)
                    .background(Color("CardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            } else {
                Menu {
                    ForEach(CalculationPreference.allCases) { method in
                        Button(action: {
                            selectedMethod = method
                        }) {
                            HStack {
                                Text(method.displayName)
                                if selectedMethod == method {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedMethod.displayName)
                            .font(.body)
                            .foregroundStyle(Color("PrimaryText"))

                        Spacer()

                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(Color("SecondaryText"))
                            .font(.caption)
                    }
                    .padding(16)
                    .background(Color("CardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }

            Toggle("Advanced Mode", isOn: $useAdvancedCalculation)
                .padding(16)
                .background(Color("CardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .tint(Color.accentColor)

            Text(
                "Only use Advanced Mode if your location doesn't follow any of the standard calculation methods above."
            )
            .font(.footnote)
            .foregroundStyle(Color("SecondaryText"))
        }
    }
}

struct AsrMadhabSelector: View {
    @Binding var selectedMadhab: MadhabPreference

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ASR CALCULATION")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color("SecondaryText"))

            VStack(spacing: 0) {
                ForEach(MadhabPreference.allCases) { madhab in
                    Button(action: {
                        selectedMadhab = madhab
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(madhab.displayName)
                                    .font(.body)
                                    .foregroundStyle(Color("PrimaryText"))

                                Text(madhab.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(Color("SecondaryText"))
                            }

                            Spacer()

                            if selectedMadhab == madhab {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accentColor)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if madhab != MadhabPreference.allCases.last {
                        Divider()
                            .padding(.leading, 16)
                    }
                }
            }
            .background(Color("CardBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("The Hanafi school uses a later time for Asr.")
                .font(.footnote)
                .foregroundStyle(Color("SecondaryText"))
        }
    }
}
