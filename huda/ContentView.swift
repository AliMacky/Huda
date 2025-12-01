//
//  ContentView.swift
//  huda
//
//  Created by Ali Macky on 11/30/25.
//

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
