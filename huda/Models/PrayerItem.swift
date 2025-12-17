/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * PrayerItem.swift
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
import Adhan

struct PrayerItem: Identifiable {
    let id = UUID()
    let name: String
    let time: String
    let arabicName: String
    let passed: Bool
    let icon: String
}

func arabicName(for prayer: Adhan.Prayer) -> String {
    switch prayer {
    case .fajr: return "الفجر"
    case .sunrise: return "الشروق"
    case .dhuhr: return "الظهر"
    case .asr: return "العصر"
    case .maghrib: return "المغرب"
    case .isha: return "العشاء"
    }
}

extension Prayer {
    var localizedName: String {
        switch self {
        case .fajr: return "fajr"
        case .sunrise: return "sunrise"
        case .dhuhr: return "dhuhr"
        case .asr: return "asr"
        case .maghrib: return "maghrib"
        case .isha: return "isha"
        }
    }
    
    static func from(localizedName: String) -> Prayer? {
        switch localizedName {
        case "fajr": return .fajr
        case "sunrise": return .sunrise
        case "dhuhr": return .dhuhr
        case "asr": return .asr
        case "maghrib": return .maghrib
        case "isha": return .isha
        default: return nil
        }
    }
}
