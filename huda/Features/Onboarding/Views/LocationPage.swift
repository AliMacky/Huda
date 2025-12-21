/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * LocationPage.swift
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

import CoreLocation
import SwiftUI

struct LocationPage: View {
    let onNext: () -> Void

    @State private var showingAddressSearch = false
    @State private var hasRequestedPermission = false
    private var locationManager = LocationManager.shared
    private var settingsManager = SettingsManager.shared

    init(onNext: @escaping () -> Void) {
        self.onNext = onNext
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 32) {
                iconView

                VStack(spacing: 16) {
                    Text(titleText)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PrimaryText"))
                        .multilineTextAlignment(.center)

                    contentView
                }
            }

            Spacer()

            bottomSection
        }
        .sheet(isPresented: $showingAddressSearch) {
            AddressSearchView { coordinate, title, timezone in
                locationManager.setManualLocation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    title: title,
                    timezone: timezone
                )
                onNext()
            }
        }
        .onChange(of: locationManager.status) { _, newStatus in
            handleAuthorizationChange(newStatus)
        }
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(Color("AccentTeal").opacity(0.15))
                .frame(width: 120, height: 120)

            Image(systemName: iconName)
                .font(.system(size: 80))
                .foregroundStyle(Color("AccentTeal"))
        }
    }

    private var iconName: String {
        switch locationManager.status {
        case .denied, .restricted:
            return "location.slash.circle.fill"
        default:
            return "location.circle.fill"
        }
    }

    private var titleText: String {
        switch locationManager.status {
        case .denied, .restricted:
            return "Location Access Needed"
        default:
            return "Enable Location"
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch locationManager.status {
        case .denied, .restricted:
            deniedContent
        default:
            defaultContent
        }
    }

    private var defaultContent: some View {
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

            InfoRow(
                icon: "arrow.triangle.turn.up.right.circle.fill",
                text: "Location is used only on your device"
            )
        }
        .padding(.horizontal, 32)
    }

    private var deniedContent: some View {
        VStack(spacing: 16) {
            Text(
                "Huda needs location access to calculate prayer times and find the Qibla direction."
            )
            .font(.subheadline)
            .foregroundStyle(Color("SecondaryText"))
            .multilineTextAlignment(.center)

            VStack(spacing: 8) {
                InfoRow(
                    icon: "exclamationmark.triangle.fill",
                    text:
                        "Even with a manual address, location permission is needed for the Qibla compass heading"
                )
            }
        }
        .padding(.horizontal, 32)
    }

    @ViewBuilder
    private var bottomSection: some View {
        switch locationManager.status {
        case .denied, .restricted:
            deniedBottomSection
        default:
            defaultBottomSection
        }
    }

    private var defaultBottomSection: some View {
        VStack(spacing: 12) {
            Button(action: requestLocationPermission) {
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

            Text("Select \"While Using the App\" when prompted")
                .font(.caption)
                .foregroundStyle(Color("TertiaryText"))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 60)
    }

    private var deniedBottomSection: some View {
        VStack(spacing: 12) {
            Button {
                showingAddressSearch = true
            } label: {
                Text("Enter Location Manually")
                    .font(.headline)
                    .foregroundStyle(Color("PrimaryText"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("AccentTeal"))
                    )
            }

            Button {
                openSettings()
            } label: {
                Text("Open Settings to Enable Location")
                    .font(.subheadline)
                    .foregroundStyle(Color("AccentTeal"))
            }

            Text("For best experience, enable location in Settings")
                .font(.caption)
                .foregroundStyle(Color("TertiaryText"))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 60)
    }

    private func requestLocationPermission() {
        hasRequestedPermission = true
        locationManager.requestPermission()
    }

    private func handleAuthorizationChange(_ status: CLAuthorizationStatus) {
        guard hasRequestedPermission else { return }

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            settingsManager.locationMode = .automatic
            onNext()
        case .denied, .restricted:
            break
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
