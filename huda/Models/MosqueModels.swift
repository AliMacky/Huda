/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * Mosque Models.swift
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
