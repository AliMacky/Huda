/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * QiblaDial.swift
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

struct QiblaDial: View {
    let heading: Double
    let relativeDirection: Double

    private var isAligned: Bool {
        let normalized =
            ((relativeDirection.truncatingRemainder(dividingBy: 360)) + 360)
                .truncatingRemainder(dividingBy: 360)
        return normalized < 5 || normalized > 355
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    isAligned
                        ? Color.green.opacity(0.3)
                        : Color("PrimaryText").opacity(0.1),
                    lineWidth: 2
                )
                .frame(width: 280, height: 280)

            Circle()
                .fill(Color("CardBackground"))
                .frame(width: 260, height: 260)

            Image(systemName: "arrow.up")
                .font(.system(size: 80, weight: .light))
                .foregroundStyle(isAligned ? Color.green : Color("AccentTeal"))
                .rotationEffect(.degrees(relativeDirection))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Qibla compass")
        .accessibilityValue(accessibilityDirectionDescription)
        .accessibilityAddTraits(.updatesFrequently)
        .onChange(of: isAligned) { _, newValue in
            if newValue {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
    }

    private var accessibilityDirectionDescription: String {
        if isAligned {
            return "Aligned with Qibla direction"
        }
        let direction = relativeDirection.truncatingRemainder(dividingBy: 360)
        let normalizedDirection = direction < 0 ? direction + 360 : direction
        if normalizedDirection <= 180 {
            return "Turn right \(Int(normalizedDirection)) degrees"
        } else {
            return "Turn left \(Int(360 - normalizedDirection)) degrees"
        }
    }
}
