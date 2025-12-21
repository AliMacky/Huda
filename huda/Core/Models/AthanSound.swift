/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * AthanSound.swift
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

enum AthanSound: String, CaseIterable, Identifiable, Codable {
    case imadi = "takbeer-ahmed-al-imadi"
    case hamathani = "takbeer-majed-al-hamathani"
    case afasy = "takbeer-mishary-rashid-al-afasy"
    case silmane = "takbeer-mokhtar-hadj-slimane"
    case qatami = "takbeer-nasser-al-qatami"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .imadi: return "Ahmed Al Imadi Takbeer"
        case .hamathani: return "Majed Al Hamathani"
        case .afasy: return "Mishary Rashid Al Afasy"
        case .silmane: return "Mokhtar Hadj Silmane"
        case .qatami: return "Nasser Al Qatami"
        }
    }

    var fileName: String {
        return rawValue + ".caf"
    }
}
