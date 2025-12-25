/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * QiblaHeader.swift
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

import _LocationEssentials
import SwiftUI

struct QiblaHeader: View {
    var locationManager = LocationManager.shared
    @State private var showCalibrationTutorial = false

    private var calibrationStatus: (text: String, color: Color) {
        let accuracy = locationManager.headingAccuracy
        if accuracy < 0 {
            return ("Calibrating...", Color("AccentOrange"))
        } else if accuracy <= 25 {
            return ("Calibrated", Color("AccentTeal"))
        } else {
            return ("Tap to calibrate", Color("AccentOrange"))
        }
    }

    private var needsCalibration: Bool {
        locationManager.headingAccuracy < 0
            || locationManager.headingAccuracy > 25
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("QIBLA DIRECTION")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("PrimaryText").opacity(0.5))
                        .tracking(1.5)

                    Text("Find your direction • القبلة")
                        .font(.subheadline)
                        .foregroundStyle(Color("SecondaryText"))
                }

                Spacer()

                Button {
                    showCalibrationTutorial = true
                } label: {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(calibrationStatus.color)
                            .frame(width: 8, height: 8)

                        Text(calibrationStatus.text)
                            .font(.caption)
                            .foregroundStyle(calibrationStatus.color)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(calibrationStatus.color.opacity(0.15))
                    )
                }
            }
            .padding(.top, 16)
        }
        .sheet(isPresented: $showCalibrationTutorial) {
            CalibrationTutorialSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
