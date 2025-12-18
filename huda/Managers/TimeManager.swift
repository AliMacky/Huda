/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * TimeManager.swift
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

import SwiftUI

/// Manages a global timer to keep the UI in sync with the current minute
@Observable
class TimeManager {
    static let shared = TimeManager()

    var now = Date()

    private var timer: Timer?

    init() {
        startTimer()
    }

    func startTimer() {
        timer?.invalidate()

        let cal = Calendar.current
        let date = Date()

        let seconds = cal.component(.second, from: date)
        let secondsUntilNextMinute = 60 - seconds

        timer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(secondsUntilNextMinute),
            repeats: false
        ) { [weak self] _ in

            self?.now = Date()

            self?.timer = Timer.scheduledTimer(
                withTimeInterval: 60,
                repeats: true
            ) { [weak self] _ in
                self?.now = Date()
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
