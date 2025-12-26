/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * AthanSoundSettingsCard.swift
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

import AVFoundation
import SwiftUI

struct AthanSoundSettingsCard: View {
    let sound: AthanSound
    let isSelected: Bool
    let onTap: () -> Void
    @Binding var currentlyPlaying: AthanSound?

    private var isPlaying: Bool {
        currentlyPlaying == sound
    }

    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(spacing: 16) {
                Image(
                    systemName: isSelected ? "checkmark.circle.fill" : "circle"
                )
                .font(.title2)
                .foregroundStyle(
                    isSelected ? Color("AccentTeal") : Color("SecondaryText")
                )
                .accessibilityHidden(true)

                Text(sound.displayName)
                    .font(.body)
                    .foregroundStyle(Color("PrimaryText"))

                Spacer()

                if isPlaying {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.body)
                        .foregroundStyle(Color("AccentTeal"))
                        .symbolEffect(.variableColor.iterative)
                        .accessibilityHidden(true)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("CardBackground"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color("AccentTeal") : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
        }
        .accessibilityLabel(accessibilityDescription)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    private var accessibilityDescription: String {
        var description = sound.displayName
        if isPlaying {
            description += ", currently playing"
        }
        return description
    }
}
