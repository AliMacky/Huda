/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * ContentView.swift
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

import Adhan
import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case home = "house.fill"
    case times = "clock.fill"
    case qibla = "location.fill"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .times: return "Times"
        case .qibla: return "Qibla"
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Color("Background").ignoresSafeArea()

            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        NavigationStack {
                            HomeView()
                                .background(
                                    Color("Background").ignoresSafeArea()
                                )
                        }
                    case .times:
                        TimesView()
                    case .qibla:
                        QiblaView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            TabBar(selected: $selectedTab)
        }
    }
}

struct TabBar: View {
    @Binding var selected: Tab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        selected = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 20))

                        Text(tab.title)
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(
                        selected == tab
                            ? Color("AccentTeal") : Color("SecondaryText")
                    )
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .padding(.horizontal, 24)
        )
    }
}

#Preview {
    ContentView()
}
