//
//  MosqueModels.swift
//  huda
//
//  Created by Ali Macky on 11/30/25.
//

import Foundation

struct MosqueSearchResults: Codable, Identifiable {
    let id: Int
    let mosqueId: Int
    let title: String
    let city: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, city, address
        case mosqueId = "masjid_id"
    }
}

struct MosqueDetails: Codable {
    let id: Int
    let title: String
    
    let fajrStartTime: String
    let shuruq: String
    let zuhrStartTime: String
    let asrStartTime: String
    let magribStartTime: String
    let ishaStartTime: String
    
    let fajrIqamaTime: String
    let zuhrIqamaTime: String
    let asrIqamaTime: String
    let magribIqamaTime: String
    let ishaIqamaTime: String
    let jumma1Iqama: String?
    let jumma2Iqama: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, shuruq
        
        case fajrStartTime = "fajr_start_time"
        case zuhrStartTime = "zuhr_start_time"
        case asrStartTime = "asr_start_time"
        case magribStartTime = "magrib_start_time"
        case ishaStartTime = "isha_start_time"
        
        case fajrIqamaTime = "fajr_iqama_time"
        case zuhrIqamaTime = "zuhr_iqama_time"
        case asrIqamaTime = "asr_iqama_time"
        case magribIqamaTime = "magrib_iqama_time" // API has differing spelling of maghrib in results :'(
        case ishaIqamaTime = "isha_iqama_time"
        
        case jumma1Iqama = "jumma1_iqama"
        case jumma2Iqama = "jumma2_iqama"
    }
}
