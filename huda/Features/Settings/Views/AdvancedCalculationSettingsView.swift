/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * AdvancedCalculationSettingsView.swift
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

struct AdvancedCalculationSettingsView: View {
    @State private var settingsManager = SettingsManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("PRAYER ANGLES")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 20)

                        VStack(spacing: 0) {
                            CalculationAngleRow(
                                title: "Fajr Angle",
                                value: $settingsManager
                                    .customCalculationParameters.fajrAngle,
                                range: 10...25
                            )

                            Divider()
                                .padding(.leading, 16)

                            CalculationAngleRow(
                                title: "Isha Angle",
                                value: $settingsManager
                                    .customCalculationParameters.ishaAngle,
                                range: 10...25
                            )
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("ISHA INTERVAL")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 20)

                        VStack(spacing: 0) {
                            Toggle(
                                "Use Interval Instead of Angle",
                                isOn: Binding(
                                    get: {
                                        settingsManager
                                            .customCalculationParameters
                                            .ishaInterval != nil
                                    },
                                    set: { enabled in
                                        if enabled {
                                            settingsManager
                                                .customCalculationParameters
                                                .ishaInterval = 90
                                        } else {
                                            settingsManager
                                                .customCalculationParameters
                                                .ishaInterval = nil
                                        }
                                    }
                                )
                            )
                            .padding(16)
                            .tint(Color.accentColor)

                            if settingsManager.customCalculationParameters
                                .ishaInterval != nil
                            {
                                Divider()
                                    .padding(.leading, 16)

                                CalculationIntervalRow(
                                    title: "Minutes After Maghrib",
                                    value: Binding(
                                        get: {
                                            settingsManager
                                                .customCalculationParameters
                                                .ishaInterval ?? 90
                                        },
                                        set: {
                                            settingsManager
                                                .customCalculationParameters
                                                .ishaInterval = $0
                                        }
                                    ),
                                    range: 30...180
                                )
                            }
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("HIGH LATITUDE RULE")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 20)

                        VStack(spacing: 0) {
                            ForEach(HighLatitudeRulePreference.allCases) {
                                rule in
                                Button(action: {
                                    settingsManager.customCalculationParameters
                                        .highLatitudeRule = rule
                                }) {
                                    HStack {
                                        Text(rule.displayName)
                                            .font(.body)
                                            .foregroundStyle(
                                                Color("PrimaryText")
                                            )

                                        Spacer()

                                        if settingsManager
                                            .customCalculationParameters
                                            .highLatitudeRule == rule
                                        {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(
                                                    Color.accentColor
                                                )
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    .padding(16)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)

                                if rule
                                    != HighLatitudeRulePreference.allCases.last
                                {
                                    Divider()
                                        .padding(.leading, 16)
                                }
                            }
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)

                        Text(
                            "Adjusts Fajr and Isha times for locations at high latitudes where twilight may persist."
                        )
                        .font(.footnote)
                        .foregroundStyle(Color("SecondaryText"))
                        .padding(.horizontal, 40)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("PRAYER ADJUSTMENTS (MINUTES)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 20)

                        VStack(spacing: 0) {
                            CalculationAdjustmentRow(
                                title: "Fajr",
                                value: $settingsManager
                                    .customCalculationParameters.adjustments
                                    .fajr
                            )
                            Divider().padding(.leading, 16)

                            CalculationAdjustmentRow(
                                title: "Sunrise",
                                value: $settingsManager
                                    .customCalculationParameters.adjustments
                                    .sunrise
                            )
                            Divider().padding(.leading, 16)

                            CalculationAdjustmentRow(
                                title: "Dhuhr",
                                value: $settingsManager
                                    .customCalculationParameters.adjustments
                                    .dhuhr
                            )
                            Divider().padding(.leading, 16)

                            CalculationAdjustmentRow(
                                title: "Asr",
                                value: $settingsManager
                                    .customCalculationParameters.adjustments.asr
                            )
                            Divider().padding(.leading, 16)

                            CalculationAdjustmentRow(
                                title: "Maghrib",
                                value: $settingsManager
                                    .customCalculationParameters.adjustments
                                    .maghrib
                            )
                            Divider().padding(.leading, 16)

                            CalculationAdjustmentRow(
                                title: "Isha",
                                value: $settingsManager
                                    .customCalculationParameters.adjustments
                                    .isha
                            )
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)

                        Text(
                            "Add or subtract minutes from each prayer time."
                        )
                        .font(.footnote)
                        .foregroundStyle(Color("SecondaryText"))
                        .padding(.horizontal, 40)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Custom Parameters")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AdvancedCalculationSettingsView()
    }
}
