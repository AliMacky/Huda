/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * OnboardingView.swift
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
import Adhan
import _LocationEssentials

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var selectedPreference: CalculationPreference = .na
    @State private var selectedMadhab: MadhabPreference = .shafi
    @State private var tempSelectedMosque: MosqueData?
    
    private var settingsManager = SettingsManager.shared
    private var locationManager = LocationManager.shared
    private var prayerManager = PrayerManager.shared
    private var notificationManager = NotificationManager.shared
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack (spacing: 0) {
                TabView(selection: $currentPage) {
                    WelcomePage(onNext: { currentPage = 1 })
                        .tag(0)
                    
                    LocationPage(onNext: {
                        locationManager.requestPermission()
                        currentPage = 2
                    })
                    .tag(1)
                    
                    CalculationMethodPage(
                        selectedPreference: $selectedPreference,
                        onNext: { currentPage = 3 },
                        currentPage: $currentPage
                    )
                    .tag(2)
                    
                    MadhabPage(
                        selectedMadhab: $selectedMadhab,
                        onNext: { currentPage = 4 },
                        currentPage: $currentPage
                    )
                    .tag(3)
                    
                    NotificationPage(
                        onNext: {
                            let granted = await notificationManager.requestPermission()
                            if granted {
                                settingsManager.notificationsEnabled = true
                                await notificationManager.scheduleAllNotifications()
                            }
                            currentPage = 5
                        },
                        currentPage: $currentPage
                    )
                    .tag(4)
                    
                    MosquePage(
                        selectedMosque: $tempSelectedMosque,
                        onComplete: {
                            saveSettings()
                        },
                        currentPage: $currentPage
                    )
                    .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(.page(backgroundDisplayMode: .never))
            }
        }
    }
    
    func saveSettings() {
        prayerManager.updateCalculationMethod(to: selectedPreference)
        prayerManager.updateAsrMadhab(to: selectedMadhab)
        settingsManager.selectedMosque = tempSelectedMosque
        settingsManager.onboardingComplete = true
    }
}

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

struct LocationPage: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 32) {
                ZStack {
                    Circle()
                        .fill(Color("AccentTeal").opacity(0.15))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Color("AccentTeal"))
                }
                
                VStack(spacing: 16) {
                    Text("Enable Location")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PrimaryText"))
                    
                    VStack(spacing: 12) {
                        InfoRow(
                            icon: "clock.fill",
                            text: "Calculate accurate prayer times for your location"
                        )
                        
                        InfoRow(
                            icon: "safari.fill",
                            text: "Find the Qibla direction wherever you are"
                        )
                        
                        InfoRow(
                            icon: "building.2.fill",
                            text: "Discover nearby mosques"
                        )
                    }
                    .padding(.horizontal, 32)
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onNext) {
                    Text("Allow Location Access")
                        .font(.headline)
                        .foregroundStyle(Color("PrimaryText"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("AccentTeal"))
                        )
                }
                
                Text("Your location is only used locally on your device")
                    .font(.caption)
                    .foregroundStyle(Color("TertiaryText"))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Color("AccentTeal"))
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Color("SecondaryText"))
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

struct CalculationMethodPage: View {
    @Binding var selectedPreference: CalculationPreference
    let onNext: () -> Void
    @Binding var currentPage: Int
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Calculation Method")
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
                VStack(spacing: 12) {
                    ForEach(CalculationPreference.allCases) { preference in
                        MethodCard(
                            title: preference.displayName,
                            isSelected: selectedPreference == preference,
                            onTap: { selectedPreference = preference }
                        )
                    }
                }
                .padding(.horizontal, 24)
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
    }
}

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
                        subtitle: preference == .shafi ? "Standard (Earlier)" : "Hanafi (Later)",
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

struct NotificationPage: View {
    let onNext: () async -> Void
    @Binding var currentPage: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 32) {
                ZStack {
                    Circle()
                        .fill(Color("AccentTeal").opacity(0.15))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Color("AccentTeal"))
                }
                
                VStack(spacing: 16) {
                    Text("Prayer Reminders")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PrimaryText"))
                    
                    VStack(spacing: 12) {
                        InfoRow(
                            icon: "bell.fill",
                            text: "Get notified when it's time to pray"
                        )
                        
                        InfoRow(
                            icon: "clock.fill",
                            text: "Never miss a prayer time"
                        )
                        
                        InfoRow(
                            icon: "moon.stars.fill",
                            text: "Notifications work even when app is closed"
                        )
                    }
                    .padding(.horizontal, 32)
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: {
                    Task {
                        await onNext()
                    }
                }) {
                    Text("Enable Notifications")
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
                        .foregroundStyle(Color("TertiaryText"))
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}

struct MosquePage: View {
    @Binding var selectedMosque: MosqueData?
    let onComplete: () -> Void
    @Binding var currentPage: Int
    @State private var showingSearch = false
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text("Find Your Mosque")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))
                
                Text("Get iqama times from your local mosque")
                    .font(.subheadline)
                    .foregroundStyle(Color("SecondaryText"))
                
                Text("Optional • يمكن تخطي هذه الخطوة")
                    .font(.caption)
                    .foregroundStyle(Color("TertiaryText"))
            }
            .padding(.top, 100)
            
            if let mosque = selectedMosque {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "building.2.fill")
                            .font(.title2)
                            .foregroundStyle(Color("AccentTeal"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(mosque.name)
                                .font(.headline)
                                .foregroundStyle(Color("PrimaryText"))
                            
                            Text(mosque.address)
                                .font(.caption)
                                .foregroundStyle(Color("SecondaryText"))
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color("AccentTeal"))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("CardBackground"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color("AccentTeal"), lineWidth: 2)
                            )
                    )
                    
                    Button(action: { selectedMosque = nil }) {
                        Text("Remove")
                            .font(.subheadline)
                            .foregroundStyle(Color("AccentOrange"))
                    }
                }
                .padding(.horizontal, 24)
            } else {
                Button(action: { showingSearch = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                        
                        Text("Search for Mosque")
                            .font(.headline)
                    }
                    .foregroundStyle(Color("AccentTeal"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("AccentTeal").opacity(0.15))
                    )
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onComplete) {
                    Text(selectedMosque == nil ? "Skip for Now" : "Complete Setup")
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
                
                if selectedMosque == nil {
                    Text("You can add a mosque later in settings")
                        .font(.caption)
                        .foregroundStyle(Color("TertiaryText"))
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
        .sheet(isPresented: $showingSearch) {
            NavigationStack {
                MosqueSearchView(selectedMosque: $selectedMosque)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingSearch = false
                            }
                        }
                    }
            }
        }
    }
}


struct MosqueSearchView: View {
    @Binding var selectedMosque: MosqueData?
    @State private var searchText = ""
    @State private var mosqueManager = MosqueManager.shared
    @State private var locationManager = LocationManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color("SecondaryText"))
                
                TextField("Search by name...", text: $searchText)
                    .foregroundStyle(Color("PrimaryText"))
                    .onSubmit {
                        performSearch()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        performSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color("SecondaryText"))
                    }
                }
            }
            .padding()
            .background(Color("CardBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
            
            if mosqueManager.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color("AccentTeal"))
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(mosqueManager.searchResults) { mosque in
                            Button {
                                selectedMosque = mosque
                                mosqueManager.searchResults = []
                                dismiss()
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(mosque.name)
                                        .font(.headline)
                                        .foregroundStyle(Color("PrimaryText"))
                                    
                                    Text(mosque.address)
                                        .font(.caption)
                                        .foregroundStyle(Color("SecondaryText"))
                                    
                                    if let dist = mosque.distance, dist != "0.00" {
                                        Text("\(dist) miles away")
                                            .font(.caption2)
                                            .foregroundStyle(Color("AccentTeal"))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("CardBackground"))
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color("Background"))
        .navigationTitle("Find Mosque")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if locationManager.location != nil && searchText.isEmpty {
                performSearch()
            }
        }
    }
    
    func performSearch() {
        Task {
            if searchText.isEmpty {
                if let location = locationManager.location {
                    let lat = String(location.latitude)
                    let lon = String(location.longitude)
                    await mosqueManager.searchMosquesByLocation(lat: lat, lon: lon)
                }
            } else {
                await mosqueManager.searchMosquesByName(name: searchText)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
