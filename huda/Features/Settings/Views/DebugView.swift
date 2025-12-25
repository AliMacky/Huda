/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) {current.year}  Ali Macky
 *
 * DebugView.swift
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

struct DebugView: View {
    let notificationManager: NotificationManager
    let settingsManager: SettingsManager

    @State private var pendingCount = 0

    private var lastScheduledText: String {
        if let date = settingsManager.lastNotificationScheduleDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return "Never"
    }

    private var lastRefreshedText: String {
        if let date = settingsManager.lastBackgroundRefreshDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return "Never"
    }

    private func updatePendingCount() async {
        pendingCount = await notificationManager.getPendingNotificationCount()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("DEBUG")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("SecondaryText"))
                    .padding(.horizontal, 4)

                Text("\(Bundle.main.formattedVersion)")
                    .font(.caption2)
                    .foregroundStyle(Color("TertiaryText"))
                    .padding(.horizontal, 4)
            }

            VStack(spacing: 0) {
                Button(action: {
                    Task {
                        await notificationManager.sendTestNotification()
                    }
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 20))
                            .frame(width: 24)
                            .foregroundStyle(Color("AccentOrange"))

                        Text("Send Test Notification")
                            .font(.body)
                            .foregroundStyle(Color("PrimaryText"))

                        Spacer()

                        Text("3 sec delay")
                            .font(.caption)
                            .foregroundStyle(Color("TertiaryText"))
                    }
                    .padding(16)
                }

                Divider()
                    .padding(.leading, 56)

                HStack(spacing: 16) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 20))
                        .frame(width: 24)
                        .foregroundStyle(Color("AccentTeal"))

                    Text("Pending Notifications")
                        .font(.body)
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    Text("\(pendingCount)")
                        .font(.subheadline)
                        .foregroundStyle(Color("SecondaryText"))
                }
                .padding(16)

                Divider()
                    .padding(.leading, 56)

                HStack(spacing: 16) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 20))
                        .frame(width: 24)
                        .foregroundStyle(Color("AccentTeal"))

                    Text("Last Scheduled")
                        .font(.body)
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    Text(lastScheduledText)
                        .font(.caption)
                        .foregroundStyle(Color("SecondaryText"))
                }
                .padding(16)

                Divider()
                    .padding(.leading, 56)

                HStack(spacing: 16) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 20))
                        .frame(width: 24)
                        .foregroundStyle(Color("AccentTeal"))

                    Text("Last BG Refresh")
                        .font(.body)
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    Text(lastRefreshedText)
                        .font(.caption)
                        .foregroundStyle(Color("SecondaryText"))
                }
                .padding(16)

                Divider()
                    .padding(.leading, 56)

                Button(action: {
                    Task {
                        await notificationManager.scheduleAllNotifications()
                        await updatePendingCount()
                    }
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20))
                            .frame(width: 24)
                            .foregroundStyle(Color("AccentTeal"))

                        Text("Reschedule All Notifications")
                            .font(.body)
                            .foregroundStyle(Color("PrimaryText"))

                        Spacer()
                    }
                    .padding(16)
                }

                Divider()
                    .padding(.leading, 56)

                Button(action: { settingsManager.onboardingComplete = false }) {
                    HStack(spacing: 16) {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.system(size: 20))
                            .frame(width: 24)
                            .foregroundStyle(Color("AccentTeal"))

                        Text("Reset Onboarding")
                            .font(.body)
                            .foregroundStyle(Color(.red))

                        Spacer()
                    }
                    .padding(16)
                }
            }
            .background(Color("CardBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .task(updatePendingCount)
    }
}
