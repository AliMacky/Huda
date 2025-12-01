/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * MosqueManager.swift
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

import Foundation
import SwiftUI

@Observable
class MosqueManager {
    static let shared = MosqueManager()
    
    var searchResults: [MosqueSearchResults] = []
    var selectedMosque: MosqueDetails?
    var isLoading = false
    
    private init() {}
    
    func searchMosques(query: String) async {
        guard !query.isEmpty else { return }
        
        let urlString = "\(Secrets.masjidiApiBaseUrl)/masjids?dist=5&searchKey=\(query)"
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(Secrets.masjidiApiKey, forHTTPHeaderField: "apikey")
        
        await MainActor.run { isLoading = true }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode([MosqueSearchResults].self, from: data)
            
            await MainActor.run {
                self.searchResults = decodedResponse
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                print("Search Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    func fetchMosqueDetails(id: Int) async {
        let urlString = "\(Secrets.masjidiApiBaseUrl)/masjids/\(id)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(Secrets.masjidiApiKey, forHTTPHeaderField: "apikey")
        
        await MainActor.run { isLoading = true }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedDetails = try JSONDecoder().decode(MosqueDetails.self, from: data)
            
            await MainActor.run {
                self.selectedMosque = decodedDetails
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                print("Search Error: \(error)")
                self.isLoading = false
            }
        }
    }
}
