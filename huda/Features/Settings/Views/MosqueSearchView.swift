/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * MosqueSearchView.swift
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
import _LocationEssentials

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

                                    if let dist = mosque.distance,
                                        dist != "0.00"
                                    {
                                        Text("\(dist) miles away")
                                            .font(.caption2)
                                            .foregroundStyle(
                                                Color("AccentTeal")
                                            )
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
                    await mosqueManager.searchMosquesByLocation(
                        lat: lat,
                        lon: lon
                    )
                }
            } else {
                await mosqueManager.searchMosquesByName(name: searchText)
            }
        }
    }
}
