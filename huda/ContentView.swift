//
//  ContentView.swift
//  huda_new
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
            testMosqueView
            
            Spacer()
            
            Text(AppInfo.fullVersionString)
        }
        .padding()
        .task {
            if let mosque = settingsManager.selectedMosque {
                print("App Launch: Found saved mosque \(mosque.title)")
                await mosqueManager.fetchMosqueDetails(id: mosque.mosqueId)
            }
        }
    }
    
    var testMosqueView: some View {
        VStack {
            TextField("Search Mosques (e.g. Redmond)", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    Task { await mosqueManager.searchMosques(query: searchText) }
                }
            
            if mosqueManager.isLoading {
                ProgressView()
            }
            
            List(mosqueManager.searchResults) { mosque in
                Button(mosque.title) {
                    settingsManager.selectedMosque = mosque
                    Task {
                        await mosqueManager.fetchMosqueDetails(id: mosque.mosqueId)
                    }
                }
            }
            
            if let details = mosqueManager.selectedMosque {
                VStack {
                    Text("Selected: \(details.title)")
                        .font(.headline)
                    
                    Text("Asr Iqama: \(details.asrIqamaTime)")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
                .padding()
            }
        }
    }
    
    var testPrayerView: some View {
        VStack {
            Spacer()
            
            if let prayers = prayerManager.currentPrayerTimes {
                Text("Fajr: \(prayers.fajr, style: .time)")
                Text("Duhr: \(prayers.dhuhr, style: .time)")
                Text("Asr: \(prayers.asr, style: .time)")
                Text("Maghrib: \(prayers.maghrib, style: .time)")
                Text("Isha: \(prayers.isha, style: .time)")
                Text("Qibla: \(prayerManager.qiblaDirection, specifier: "%.2f")°")
            } else {
                Button("Enable Location") {
                    locationManager.requestPermission()
                }
            }
            
            Spacer()
            
            Button("Switch to Hanafi") {
                prayerManager.updateAsrMadhab(to: .hanafi)
            }
            
            Button("Switch to Standard") {
                prayerManager.updateAsrMadhab(to: .shafi)
            }
            
            Spacer()
            
            Button("Switch to Karachi") {
                prayerManager.updateCalculationMethod(to: .karachi)
            }
            
            Button("Switch to North America") {
                prayerManager.updateCalculationMethod(to: .northAmerica)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
