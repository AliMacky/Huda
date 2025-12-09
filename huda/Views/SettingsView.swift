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
import _LocationEssentials

struct SettingsView: View {
    @State private var settingsManager = SettingsManager.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showingMosqueSearch = false
    
    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CALCULATION SETTINGS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: CalculationMethodSettingsView()) {
                                SettingsRow(
                                    icon: "clock.fill",
                                    title: "Calculation Method",
                                    value: settingsManager.selectedMethod.displayName
                                )
                            }
                            
                            Divider()
                                .padding(.leading, 56)
                            
                            NavigationLink(destination: MadhabSettingsView()) {
                                SettingsRow(
                                    icon: "sun.max.fill",
                                    title: "Asr Calculation",
                                    value: settingsManager.selectedAsrMadhab.displayName
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
                                
                                Button(action: { settingsManager.selectedMosque = nil }) {
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
                    
                    Button(action: { settingsManager.selectedMosque = nil }) {
                        HStack(alignment: .center, spacing: 16) {
                            Spacer()
                            Text("Reset Onboarding")
                                .font(.body)
                                .foregroundStyle(.red)
                            Spacer()
                        }
                        .padding(16)
                    }
                    .background(Color("CardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Button(action: { NotificationManager.shared.testNotification() }) {
                        HStack(alignment: .center, spacing: 16) {
                            Spacer()
                            Text("Test Notification")
                                .font(.body)
                                .foregroundStyle(.red)
                            Spacer()
                        }
                        .padding(16)
                    }
                    .background(Color("CardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 16));
                }
                .padding(20)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingMosqueSearch) {
            NavigationStack {
                MosqueSearchView(selectedMosque: Binding(
                    get: { settingsManager.selectedMosque },
                    set: { settingsManager.selectedMosque = $0 }
                ))
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: 24)
                .foregroundStyle(Color("AccentTeal"))
            
            Text(title)
                .font(.body)
                .foregroundStyle(Color("PrimaryText"))
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundStyle(Color("SecondaryText"))
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Color("TertiaryText"))
        }
        .padding(16)
    }
}

struct CalculationMethodSettingsView: View {
    @State private var settingsManager = SettingsManager.shared
    @State private var prayerManager = PrayerManager.shared
    
    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(CalculationPreference.allCases) { preference in
                        MethodCard(
                            title: preference.displayName,
                            isSelected: settingsManager.selectedMethod == preference,
                            onTap: { prayerManager.updateCalculationMethod(to: preference) }
                        )
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Calculation Method")
    }
}

struct MadhabSettingsView: View {
    @State private var settingsManager = SettingsManager.shared
    @State private var prayerManager = PrayerManager.shared
    
    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(MadhabPreference.allCases) { preference in
                        MethodCard(
                            title: preference.displayName,
                            subtitle: preference == .shafi ? "Standard (Earlier)" : "Hanafi (Later)",
                            isSelected: settingsManager.selectedAsrMadhab == preference,
                            onTap: { prayerManager.updateAsrMadhab(to: preference) }
                        )
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Asr Calculation")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
