/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * SettingsView.swift
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

struct SettingsView: View {
    @State private var settingsManager = SettingsManager.shared
    @State private var notificationManager = NotificationManager.shared
    @Environment(\.dismiss) var dismiss

    @State private var showingMosqueSearch = false

    private var notificationSummary: String {
        let modes = settingsManager.prayerNotificationModes
        let athanCount = modes.values.filter { $0 == .athan }.count
        let silentCount = modes.values.filter { $0 == .silent }.count

        if athanCount == 5 {
            return "All with Athan"
        } else if athanCount + silentCount == 0 {
            return "Off"
        } else {
            return "\(athanCount) Athan, \(silentCount) Silent"
        }
    }

    private var locationValueText: String {
        switch settingsManager.locationMode {
        case .automatic:
            return "Automatic"
        case .manual:
            return settingsManager.manualLocationTitle ?? "Manual"
        }
    }

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("LOCATION SETTINGS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 4)

                        NavigationLink(destination: LocationSettingsView()) {
                            SettingsRow(
                                icon: "location.fill",
                                title: "Location",
                                value: locationValueText
                            )
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("CALCULATION SETTINGS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 4)

                        VStack(spacing: 0) {
                            NavigationLink(
                                destination: CalculationMethodSettingsView()
                            ) {
                                SettingsRow(
                                    icon: "clock.fill",
                                    title: "Calculation Method",
                                    value: settingsManager.selectedMethod
                                        .displayName
                                )
                            }

                            Divider()
                                .padding(.leading, 56)

                            NavigationLink(destination: MadhabSettingsView()) {
                                SettingsRow(
                                    icon: "sun.max.fill",
                                    title: "Asr Calculation",
                                    value: settingsManager.selectedAsrMadhab
                                        .displayName
                                )
                            }
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("MOSQUE SETTINGS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 4)

                        VStack(spacing: 0) {
                            if let mosque = settingsManager.selectedMosque {
                                Button(action: { showingMosqueSearch = true }) {
                                    SettingsRow(
                                        icon: "building.2.fill",
                                        title: "Selected Mosque",
                                        value: mosque.name
                                    )
                                }

                                Divider()
                                    .padding(.leading, 56)

                                Button(action: {
                                    settingsManager.selectedMosque = nil
                                }) {
                                    HStack(spacing: 16) {
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 20))
                                            .frame(width: 24)
                                            .foregroundStyle(.red)

                                        Text("Remove Selected Mosque")
                                            .font(.body)
                                            .foregroundStyle(.red)

                                        Spacer()
                                    }
                                    .padding(16)
                                }
                            } else {
                                Button(action: { showingMosqueSearch = true }) {
                                    SettingsRow(
                                        icon: "building.2.fill",
                                        title: "Select Mosque",
                                        value: "None"
                                    )
                                }
                            }
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("NOTIFICATION SETTINGS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 4)

                        NavigationLink(
                            destination: NotificationSettingsView(
                                settingsManager: settingsManager,
                                notificationManager: notificationManager
                            )
                        ) {
                            SettingsRow(
                                icon: "bell.fill",
                                title: "Prayer Notifications",
                                value: notificationSummary
                            )
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    #if DEBUG
                        DebugView(
                            notificationManager: notificationManager,
                            settingsManager: settingsManager
                        )
                    #endif
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)

            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingMosqueSearch) {
            NavigationStack {
                MosqueSearchView(
                    selectedMosque: Binding(
                        get: { settingsManager.selectedMosque },
                        set: { settingsManager.selectedMosque = $0 }
                    )
                )
            }
        }
    }
}
