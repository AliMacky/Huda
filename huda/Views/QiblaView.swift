/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * QiblaView.swift
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
import _LocationEssentials

struct QiblaView: View {
    var prayerManager = PrayerManager.shared
    var locationManager = LocationManager.shared
    var relativeDirection: Double {
        return prayerManager.qiblaDirection - locationManager.heading
    }
    
    var body: some View {
        VStack {
            QiblaHeader()
            
            Spacer()
            
            QiblaDial(heading: locationManager.heading, relativeDirection: relativeDirection)
            
            Spacer()
            
            VStack (spacing: 12) {
                DirectionCard(qiblaDirection: prayerManager.qiblaDirection, cardinalDirection: cardinalDirection(from: prayerManager.qiblaDirection))
                
                LocationCard(locationTitle: locationManager.locationTitle, coordinates: locationManager.location)
            }
            
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 100)
        .onAppear {
            locationManager.startUpdatingHeading()
        }
        .onDisappear {
            locationManager.stopUpdatingHeading()
        }
    }
    
    private func cardinalDirection(from degrees: Double) -> String {
        let directions = ["North", "North East", "East", "South East", "South", "South West", "West", "North West"]
        let index = Int((degrees + 22.5) / 45.0) % 8
        return directions[index]
    }
}

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
        locationManager.headingAccuracy < 0 || locationManager.headingAccuracy > 25
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

struct CalibrationTutorialSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Calibrate Your Compass")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color("PrimaryText"))
            
            Text("∞")
                .font(.system(size: 80))
                .foregroundStyle(Color("AccentTeal"))
            
            Text("Move your phone in a figure-8 pattern until the compass is calibrated.")
                .font(.body)
                .foregroundStyle(Color("SecondaryText"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button {
                dismiss()
            } label: {
                Text("Got it")
                    .font(.headline)
                    .foregroundStyle(Color("PrimaryText"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentTeal"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
        .padding(.top, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

struct LocationCard: View {
    let locationTitle: String?
    let coordinates: CLLocationCoordinate2D?
    
    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundStyle(Color("AccentOrange"))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Your Location")
                    .font(.caption)
                    .foregroundStyle(Color("PrimaryText").opacity(0.5))
                
                Text(locationTitle ?? "Unknown")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color("PrimaryText"))
            }
            
            Spacer()
            
            if let location = coordinates {
                Text("\(String(format: "%.2f", location.latitude))° \(location.latitude >= 0 ? "N" : "S"), \(String(format: "%.2f", abs(location.longitude)))° \(location.longitude >= 0 ? "E" : "W")")
                    .font(.caption2)
                    .foregroundStyle(Color("TertiaryText"))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground").opacity(0.6))
        )
    }
}

struct DirectionCard: View {
    let qiblaDirection: Double
    let cardinalDirection: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("DIRECTION")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("PrimaryText").opacity(0.5))
                    .tracking(1.2)
                
                HStack(spacing: 8) {
                    Text("\(Int(qiblaDirection))°")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("AccentTeal"))
                    
                    Text(cardinalDirection)
                        .font(.subheadline)
                        .foregroundStyle(Color("SecondaryText"))
                }
            }
            
            Spacer()
            
            Image(systemName: "safari")
                .font(.system(size: 32))
                .foregroundStyle(Color("AccentTeal").opacity(0.3))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
        )
    }
}

struct QiblaDial: View {
    let heading: Double
    let relativeDirection: Double
    
    private var isAligned: Bool {
        let normalized = ((relativeDirection.truncatingRemainder(dividingBy: 360)) + 360).truncatingRemainder(dividingBy: 360)
        return normalized < 5 || normalized > 355
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(isAligned ? Color.green.opacity(0.3) : Color("PrimaryText").opacity(0.1), lineWidth: 2)
                .frame(width: 280, height: 280)
            
            Circle()
                .fill(Color("CardBackground"))
                .frame(width: 260, height: 260)
            
            Image(systemName: "arrow.up")
                .font(.system(size: 80, weight: .light))
                .foregroundStyle(isAligned ? Color.green : Color("AccentTeal"))
                .rotationEffect(.degrees(relativeDirection))
        }
        .onChange(of: isAligned) { oldValue, newValue in
            if newValue {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
    }
}

#Preview {
    QiblaView()
}
