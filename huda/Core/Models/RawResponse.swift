/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * RawResponse.swift
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

struct RawResponse: Decodable {
    let items: [RawMosque]
}

/// API response structure for 1 day's worth of prayer
struct RawDay: Decodable {
    let date: String
    let salah: MosquePrayerTimes.Daily
    let iqamah: MosquePrayerTimes.Daily
}

/// API response structure for a mosque
struct RawMosque: Decodable {
    let id: String
    let times: [RawDay]
}
