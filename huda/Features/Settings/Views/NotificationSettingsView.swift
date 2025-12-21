/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * NotificationSettingsView.swift
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

struct NotificationSettingsView: View {
    var settingsManager: SettingsManager
    var notificationManager: NotificationManager

    @State private var currentlyPlayingSound: AthanSound? = nil

    // Kept local to avoid global state issues if this view is unique
    @State private var localAudioPlayer: AVAudioPlayer?

    private let prayers: [(key: String, name: String)] = [
        ("fajr", "Fajr"),
        ("dhuhr", "Dhuhr"),
        ("asr", "Asr"),
        ("maghrib", "Maghrib"),
        ("isha", "Isha"),
    ]

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("NOTIFICATION TYPE")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 4)

                        VStack(spacing: 8) {
                            ForEach(prayers, id: \.key) { prayer in
                                NotificationSettingsRow(
                                    prayerName: prayer.name,
                                    prayerKey: prayer.key,
                                    settingsManager: settingsManager,
                                )
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("ATHAN SOUND")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("SecondaryText"))
                            .padding(.horizontal, 4)

                        VStack(spacing: 8) {
                            ForEach(AthanSound.allCases) { sound in
                                AthanSoundSettingsCard(
                                    sound: sound,
                                    isSelected: settingsManager
                                        .selectedAthanSound == sound,
                                    onTap: {
                                        settingsManager.selectedAthanSound =
                                            sound
                                        playAudio(sound: sound)
                                        rescheduleNotifications()
                                    },
                                    currentlyPlaying: $currentlyPlayingSound
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Prayer Notifications")
        .navigationTitle("Prayer Notifications")
        .onDisappear {
            localAudioPlayer?.stop()
            currentlyPlayingSound = nil
        }
    }

    private func rescheduleNotifications() {
        Task {
            await notificationManager.scheduleAllNotifications()
        }
    }

    private func playAudio(sound: AthanSound) {
        // Stop current player if exists
        localAudioPlayer?.stop()

        currentlyPlayingSound = sound

        guard
            let url = Bundle.main.url(
                forResource: sound.rawValue,
                withExtension: "caf"
            )
        else {
            currentlyPlayingSound = nil
            return
        }

        do {
            localAudioPlayer = try AVAudioPlayer(contentsOf: url)
            localAudioPlayer?.play()

            let duration = localAudioPlayer?.duration ?? 0
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                if currentlyPlayingSound == sound {
                    currentlyPlayingSound = nil
                }
            }
        } catch {
            currentlyPlayingSound = nil
        }
    }
}
