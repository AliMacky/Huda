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

struct MosqueData: Codable, Identifiable {
    let id: String
    let name: String
    let city: String
    let state: String?
    let country: String
    let latitude: String
    let longitude: String
    
    let address: String
    let zipcode: String
    let distance: String?
    let websiteUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case websiteUrl = "website_url"
        case id, name, city, state, country, latitude, longitude, address, zipcode, distance
    }
}

struct MosqueSearchResponse: Codable {
    let items: [MosqueData]
}

struct DailyPrayers: Codable {
    let fajr: String
    let zuhr: String
    let asr: String
    let maghrib: String
    let isha: String
    let jumuah1: String?
    let jumuah2: String?
}

struct MosquePrayerTimes: Codable, Identifiable {
    var id: String { return "\(mosqueId)-\(date)" }
    
    let mosqueId: String
    let date: String
    let athan: DailyPrayers
    let iqama: DailyPrayers
}

struct MosqueIqamaState {
    let prayerName: String
    let iqamaTime: String
    let timeUntil: String
    let minutesAfterAdhan: Int
}
