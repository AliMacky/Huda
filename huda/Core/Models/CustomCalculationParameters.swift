/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * CustomCalculationParameters.swift
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

import Adhan
import Foundation

enum HighLatitudeRulePreference: String, CaseIterable, Identifiable, Codable {
    case middleOfTheNight
    case seventhOfTheNight
    case twilightAngle

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .middleOfTheNight: return "Middle of the Night"
        case .seventhOfTheNight: return "Seventh of the Night"
        case .twilightAngle: return "Twilight Angle"
        }
    }

    var packageValue: HighLatitudeRule {
        switch self {
        case .middleOfTheNight: return .middleOfTheNight
        case .seventhOfTheNight: return .seventhOfTheNight
        case .twilightAngle: return .twilightAngle
        }
    }
}

struct PrayerAdjustmentsModel: Codable, Equatable {
    var fajr: Int = 0
    var sunrise: Int = 0
    var dhuhr: Int = 0
    var asr: Int = 0
    var maghrib: Int = 0
    var isha: Int = 0

    var packageValue: PrayerAdjustments {
        var adjustments = PrayerAdjustments()
        adjustments.fajr = fajr
        adjustments.sunrise = sunrise
        adjustments.dhuhr = dhuhr
        adjustments.asr = asr
        adjustments.maghrib = maghrib
        adjustments.isha = isha
        return adjustments
    }
}

struct CustomCalculationParameters: Codable, Equatable {
    var fajrAngle: Double = 18.0
    var ishaAngle: Double = 17.0
    var ishaInterval: Int? = nil
    var highLatitudeRule: HighLatitudeRulePreference = .middleOfTheNight
    var adjustments: PrayerAdjustmentsModel = .init()
}
