//
//  MosqueManager.swift
//  huda_new
//
//  Created by Ali Macky on 11/30/25.
//

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
