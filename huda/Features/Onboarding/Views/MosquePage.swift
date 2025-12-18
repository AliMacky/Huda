/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * MosquePage.swift
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
                    Text(
                        selectedMosque == nil
                            ? "Skip for Now" : "Complete Setup"
                    )
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
