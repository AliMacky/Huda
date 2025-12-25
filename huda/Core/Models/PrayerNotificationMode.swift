/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * PrayerNotificationMode.swift
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

enum PrayerNotificationMode: String, CaseIterable, Identifiable, Codable {
    case off
    case silent
    case athan

    var id: String { rawValue }

    /// Represents the enum as a display string
    var displayName: String {
        switch self {
        case .off: return "Off"
        case .silent: return "Silent"
        case .athan: return "Athan"
        }
    }

    var icon: String {
        switch self {
        case .off: return "bell.slash"
        case .silent: return "bell"
        case .athan: return "bell.and.waves.left.and.right"
        }
    }
}
