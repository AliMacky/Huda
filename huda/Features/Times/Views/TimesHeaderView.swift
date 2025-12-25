/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) {current.year}  Ali Macky
 *
 * TimesHeaderView.swift
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

struct TimesHeaderView: View {
    @Binding var selectedDate: Date

    private var weekDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0 ..< 7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: today)
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Prayer Times")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PrimaryText"))

                    Text("Salah • صلاة")
                        .font(.caption)
                        .foregroundStyle(Color("SecondaryText"))
                }

                Spacer()
            }

            HStack(spacing: 8) {
                ForEach(weekDates, id: \.self) { date in
                    WeekDayButton(
                        date: date,
                        isSelected: Calendar.current.isDate(
                            date,
                            inSameDayAs: selectedDate
                        ),
                        action: { selectedDate = date }
                    )
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}
