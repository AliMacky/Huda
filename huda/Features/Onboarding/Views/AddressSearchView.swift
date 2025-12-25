/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * AddressSearchView.swift
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
import MapKit
import SwiftUI

struct AddressSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var isSearching = false
    @State private var completer = SearchCompleter()

    let onLocationSelected: (CLLocationCoordinate2D, String, String) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    searchField

                    if isSearching {
                        ProgressView()
                            .padding(.top, 40)
                        Spacer()
                    } else if searchResults.isEmpty && !searchText.isEmpty {
                        emptyState
                    } else {
                        resultsList
                    }
                }
            }
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color("AccentTeal"))
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            completer.search(query: newValue)
        }
        .onChange(of: completer.results) { _, newResults in
            searchResults = newResults
        }
    }

    private var searchField: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color("TertiaryText"))

            TextField("Search for a city or address", text: $searchText)
                .foregroundStyle(Color("PrimaryText"))
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    searchResults = []
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color("TertiaryText"))
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CardBackground"))
        )
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(Color("TertiaryText"))

            Text("No results found")
                .font(.headline)
                .foregroundStyle(Color("SecondaryText"))

            Text("Try searching for a different city or address")
                .font(.subheadline)
                .foregroundStyle(Color("TertiaryText"))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(searchResults, id: \.self) { result in
                    Button {
                        selectLocation(result)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color("AccentTeal"))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(result.title)
                                    .font(.body)
                                    .foregroundStyle(Color("PrimaryText"))
                                    .lineLimit(1)

                                if !result.subtitle.isEmpty {
                                    Text(result.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(Color("TertiaryText"))
                                        .lineLimit(1)
                                }
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color("TertiaryText"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }

                    Divider()
                        .padding(.leading, 52)
                }
            }
            .padding(.top, 8)
        }
    }

    private func selectLocation(_ completion: MKLocalSearchCompletion) {
        isSearching = true

        Task {
            do {
                let request = MKLocalSearch.Request(completion: completion)
                let search = MKLocalSearch(request: request)
                let response = try await search.start()

                if let item = response.mapItems.first {
                    let coordinate = item.location.coordinate
                    let title = formatLocationTitle(from: item)
                    let timezone = await fetchTimezone(for: item.location)

                    await MainActor.run {
                        isSearching = false
                        onLocationSelected(coordinate, title, timezone)
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    isSearching = false
                }
                print("Search Error: \(error.localizedDescription)")
            }
        }
    }

    private func fetchTimezone(for location: CLLocation) async -> String {
        do {
            let placemarks = MKReverseGeocodingRequest(location: location)
            if let timezone = placemarks?.preferredLocale?.timeZone {
                return timezone.identifier
            }
        }
        return TimeZone.current.identifier
    }

    private func formatLocationTitle(from item: MKMapItem) -> String {
        if let representations = item.addressRepresentations,
           let cityContext = representations.cityWithContext
        {
            return cityContext
        }
        return item.name ?? "Unknown Location"
    }
}

@Observable
private class SearchCompleter: NSObject, MKLocalSearchCompleterDelegate {
    var results: [MKLocalSearchCompletion] = []
    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
    }

    func search(query: String) {
        guard !query.isEmpty else {
            results = []
            return
        }
        completer.queryFragment = query
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }

    func completer(
        _: MKLocalSearchCompleter,
        didFailWithError error: Error
    ) {
        print("Completer Error: \(error.localizedDescription)")
    }
}
