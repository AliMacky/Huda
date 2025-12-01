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


import SwiftUI
import Adhan

struct ContentView: View {
    var locationManager = LocationManager.shared
    var prayerManager = PrayerManager.shared
    var settingsManager = SettingsManager.shared
    var mosqueManager = MosqueManager.shared
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            Text("Huda \(AppInfo.fullVersionString)")
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
}
