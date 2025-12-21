/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * LocationSettingsView.swift
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

struct LocationSettingsView: View {
    @State private var settingsManager = SettingsManager.shared
    @State private var locationManager = LocationManager.shared
    @State private var showingAddressSearch = false

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    locationModeSection
                    currentLocationSection

                    if settingsManager.locationMode == .manual {
                        changeLocationSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Location")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddressSearch) {
            AddressSearchView { coordinate, title, timezone in
                locationManager.setManualLocation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    title: title,
                    timezone: timezone
                )
            }
        }
    }

    private var locationModeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("LOCATION MODE")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color("SecondaryText"))
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                Button {
                    settingsManager.locationMode = .automatic
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 20))
                            .frame(width: 24)
                            .foregroundStyle(Color("AccentTeal"))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Automatic")
                                .font(.body)
                                .foregroundStyle(Color("PrimaryText"))

                            Text("Use GPS to detect your location")
                                .font(.caption)
                                .foregroundStyle(Color("TertiaryText"))
                        }

                        Spacer()

                        if settingsManager.locationMode == .automatic {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("AccentTeal"))
                        }
                    }
                    .padding(16)
                }

                Divider()
                    .padding(.leading, 56)

                Button {
                    if settingsManager.manualLocationTitle == nil {
                        showingAddressSearch = true
                    } else {
                        settingsManager.locationMode = .manual
                    }
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 20))
                            .frame(width: 24)
                            .foregroundStyle(Color("AccentTeal"))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Manual")
                                .font(.body)
                                .foregroundStyle(Color("PrimaryText"))

                            Text("Use a fixed address you specify")
                                .font(.caption)
                                .foregroundStyle(Color("TertiaryText"))
                        }

                        Spacer()

                        if settingsManager.locationMode == .manual {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("AccentTeal"))
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color("CardBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var currentLocationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CURRENT LOCATION")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color("SecondaryText"))
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Image(
                        systemName: settingsManager.locationMode == .automatic
                            ? "location.fill" : "mappin.circle.fill"
                    )
                    .font(.system(size: 20))
                    .frame(width: 24)
                    .foregroundStyle(Color("AccentTeal"))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentLocationTitle)
                            .font(.body)
                            .foregroundStyle(Color("PrimaryText"))

                        if let coordinate = locationManager.effectiveLocation {
                            Text(formatCoordinates(coordinate))
                                .font(.caption)
                                .foregroundStyle(Color("TertiaryText"))
                        }
                    }

                    Spacer()
                }
                .padding(16)
            }
            .background(Color("CardBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var changeLocationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("MANUAL LOCATION")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color("SecondaryText"))
                .padding(.horizontal, 4)

            Button {
                showingAddressSearch = true
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .frame(width: 24)
                        .foregroundStyle(Color("AccentTeal"))

                    Text("Change Location")
                        .font(.body)
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color("TertiaryText"))
                }
                .padding(16)
            }
            .background(Color("CardBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var currentLocationTitle: String {
        if let title = locationManager.effectiveLocationTitle, !title.isEmpty {
            return title
        }
        return "Unknown Location"
    }

    private func formatCoordinates(_ coordinate: CLLocationCoordinate2D)
        -> String
    {
        let lat = String(format: "%.4f", coordinate.latitude)
        let lon = String(format: "%.4f", coordinate.longitude)
        return "\(lat), \(lon)"
    }
}
