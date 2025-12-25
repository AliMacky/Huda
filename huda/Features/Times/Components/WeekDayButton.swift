/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * WeekDayButton.swift
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

struct WeekDayButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void

    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    private var dayName: String {
        date.formatted(.dateTime.weekday(.abbreviated))
    }

    private var dayNumber: String {
        date.formatted(.dateTime.day())
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(dayName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(
                        isSelected
                            ? Color("PrimaryText")
                            : Color("SecondaryText")
                    )

                Text(dayNumber)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))

                if isToday {
                    Circle()
                        .fill(
                            isSelected
                                ? Color("PrimaryText")
                                : Color("AccentTeal")
                        )
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected
                            ? Color("AccentTeal")
                            : Color("CardBackground")
                    )
            )
        }
    }
}
