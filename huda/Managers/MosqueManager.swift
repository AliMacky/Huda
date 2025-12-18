/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * MosqueManager.swift
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

import Foundation
import SwiftUI

@Observable
class MosqueManager {
    static let shared = MosqueManager()

    var searchResults: [MosqueData] = []
    var prayerTimes: [MosquePrayerTimes] = []

    var isLoading = false

    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private init() {}

    private func saveToCache(times: [MosquePrayerTimes], mosqueId: String) {
        if let encoded = try? JSONEncoder().encode(times) {
            UserDefaults.standard.set(
                encoded,
                forKey: "cached_schedule_\(mosqueId)"
            )
        }
    }

    func loadFromCache(mosqueId: String) -> Bool {
        guard
            let data = UserDefaults.standard.data(
                forKey: "cached_schedule_\(mosqueId)"
            ),
            let decoded = try? JSONDecoder().decode(
                [MosquePrayerTimes].self,
                from: data
            )
        else {
            return false
        }

        let todayString = apiDateFormatter.string(from: Date())
        let hasToday = decoded.contains { $0.date == todayString }

        if hasToday {
            self.prayerTimes = decoded
            return true
        } else {
            return false
        }
    }

    func searchMosquesByLocation(lat: String, lon: String) async {
        guard !lat.isEmpty, !lon.isEmpty else { return }

        let urlString =
            "\(Secrets.masjidalApiBaseUrl)/v3/masjids/proximity?distance=50&per-page=5&lat=\(lat)&long=\(lon)"
        guard
            let encodedString = urlString.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedString)
        else {
            return
        }

        let request = URLRequest(url: url)

        await MainActor.run { isLoading = true }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(
                MosqueSearchResponse.self,
                from: data
            )

            await MainActor.run {
                self.searchResults = decodedResponse.items
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                print("Search Error: \(error)")
                self.isLoading = false
            }
        }
    }

    func searchMosquesByName(name: String) async {
        guard !name.isEmpty else { return }

        let urlString = "\(Secrets.masjidalApiBaseUrl)/v3/masjids?name=\(name)"
        guard
            let encodedString = urlString.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedString)
        else {
            return
        }

        let request = URLRequest(url: url)

        await MainActor.run { isLoading = true }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(
                MosqueSearchResponse.self,
                from: data
            )

            await MainActor.run {
                self.searchResults = decodedResponse.items
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                print("Search Error: \(error)")
                self.isLoading = false
            }
        }
    }

    func fetchMosquePrayerTimes(mosque: MosqueData) async {
        if loadFromCache(mosqueId: mosque.id) {
            return
        }

        let calendar = Calendar.current
        let now = Date()

        let components = calendar.dateComponents([.year, .month], from: now)
        guard let startOfMonth = calendar.date(from: components),
            let nextMonth = calendar.date(
                byAdding: .month,
                value: 1,
                to: startOfMonth
            ),
            let endOfMonth = calendar.date(
                byAdding: .day,
                value: -1,
                to: nextMonth
            )
        else { return }

        let fromStr = startOfMonth.formatted(
            .iso8601.year().month().day().dateSeparator(.dash)
        )
        let toStr = endOfMonth.formatted(
            .iso8601.year().month().day().dateSeparator(.dash)
        )

        let urlString =
            "\(Secrets.masjidalApiBaseUrl)/v3/masjids/proximity?distance=1&expand=times&per-page=1&lat=\(mosque.latitude)&long=\(mosque.longitude)&date_start=\(fromStr)&date_end=\(toStr)"

        guard
            let encodedString = urlString.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedString)
        else { return }

        await MainActor.run { isLoading = true }

        do {
            let (data, _) = try await URLSession.shared.data(
                for: URLRequest(url: url)
            )

            let decodedResponse = try JSONDecoder().decode(
                RawResponse.self,
                from: data
            )

            let flattenedList: [MosquePrayerTimes] = decodedResponse.items
                .flatMap { mosqueItem in
                    return mosqueItem.times.map { day in
                        return MosquePrayerTimes(
                            mosqueId: mosqueItem.id,
                            date: day.date,
                            athan: day.salah,
                            iqama: day.iqamah
                        )
                    }
                }

            await MainActor.run {
                self.prayerTimes = flattenedList
                self.isLoading = false

                self.saveToCache(times: flattenedList, mosqueId: mosque.id)
            }

        } catch {
            await MainActor.run {
                print("Fetch Error: \(error)")
                self.isLoading = false
            }
        }
    }

    func getNextIqama(for date: Date = Date()) -> MosquePrayerTimes.IqamaState?
    {
        guard !prayerTimes.isEmpty else { return nil }

        let fullFormatter = DateFormatter()
        fullFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        fullFormatter.locale = Locale(identifier: "en_US_POSIX")

        let now = date
        let calendar = Calendar.current

        func checkPrayers(for lookupDate: Date) -> MosquePrayerTimes.IqamaState?
        {
            let lookupFormatter = DateFormatter()
            lookupFormatter.dateFormat = "EEEE, MMM d, yyyy"
            lookupFormatter.locale = Locale(identifier: "en_US_POSIX")
            let lookupString = lookupFormatter.string(from: lookupDate)

            guard
                let daySchedule = prayerTimes.first(where: {
                    $0.date == lookupString
                })
            else { return nil }

            let prayers: [(name: String, athan: String, iqama: String)] = [
                ("Fajr", daySchedule.athan.fajr, daySchedule.iqama.fajr),
                ("Dhuhr", daySchedule.athan.zuhr, daySchedule.iqama.zuhr),
                ("Asr", daySchedule.athan.asr, daySchedule.iqama.asr),
                (
                    "Maghrib", daySchedule.athan.maghrib,
                    daySchedule.iqama.maghrib
                ),
                ("Isha", daySchedule.athan.isha, daySchedule.iqama.isha),
            ]

            for p in prayers {
                let iqamaString = "\(daySchedule.date) \(p.iqama)"
                let athanString = "\(daySchedule.date) \(p.athan)"

                if let iqamaDate = fullFormatter.date(from: iqamaString),
                    let athanDate = fullFormatter.date(from: athanString)
                {

                    if iqamaDate > now {
                        let diff = iqamaDate.timeIntervalSince(now)
                        let hours = Int(diff) / 3600
                        let minutes = (Int(diff) % 3600) / 60
                        let timeUntilStr =
                            hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"

                        let offset = Int(
                            iqamaDate.timeIntervalSince(athanDate) / 60
                        )

                        return MosquePrayerTimes.IqamaState(
                            prayerName: p.name,
                            iqamaTime: p.iqama,
                            timeUntil: timeUntilStr,
                            minutesAfterAdhan: offset
                        )
                    }
                }
            }
            return nil
        }

        if let state = checkPrayers(for: now) {
            return state
        }

        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) {
            return checkPrayers(for: tomorrow)
        }

        return nil
    }
}
