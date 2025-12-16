/*
 * Huda – Islamic iOS app for prayer times and Qibla direction
 * Copyright (C) 2025  Ali Macky
 *
 * NetworkMonitor.swift
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
import Network

@Observable
class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor", qos: .userInitiated)
    
    var isConnected: Bool = true
    
    private init() {
        let semaphore = DispatchSemaphore(value: 0)
        var initialStatus: NWPath.Status = .satisfied
        
        monitor.pathUpdateHandler = { [weak self] path in
            initialStatus = path.status
            semaphore.signal()
            
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        
        monitor.start(queue: queue)
        
        _ = semaphore.wait(timeout: .now() + 0.5)
        isConnected = (initialStatus == .satisfied)
    }
}
