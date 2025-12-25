/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * CalculationPreference.swift
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

enum CalculationPreference: String, CaseIterable, Identifiable, Codable {
    case dubai
    case egyptian
    case karachi
    case kuwait
    case msc
    case mwl
    case na
    case qatar
    case singapore
    case tehran
    case turkey
    case uq

    var id: String { rawValue }

    /// Represents the enum as a display string
    var displayName: String {
        switch self {
        case .dubai: return "Dubai"
        case .egyptian: return "Egyptian"
        case .karachi: return "Karachi"
        case .kuwait: return "Kuwait"
        case .msc: return "Moonsighting Committee"
        case .mwl: return "Muslim World League"
        case .na: return "North America"
        case .qatar: return "Qatar"
        case .singapore: return "Singapore"
        case .tehran: return "Tehran"
        case .turkey: return "Turkey"
        case .uq: return "Umm Al-Qura"
        }
    }

    var packageValue: CalculationMethod {
        switch self {
        case .dubai: return .dubai
        case .egyptian: return .egyptian
        case .karachi: return .karachi
        case .kuwait: return .kuwait
        case .msc: return .moonsightingCommittee
        case .mwl: return .muslimWorldLeague
        case .na: return .northAmerica
        case .qatar: return .qatar
        case .singapore: return .singapore
        case .tehran: return .tehran
        case .turkey: return .turkey
        case .uq: return .ummAlQura
        }
    }
}
