//
//  SecretsManager.swift
//  huda_new
//
//  Created by Ali Macky on 11/30/25.
//

import Foundation

struct Secrets {
    static var masjidiApiKey: String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let key = dict["Masjidi Api Key"] as? String else {
            
            fatalError("API Key not found in Info.plist")
        }
        return key
    }
    
    static var masjidiApiBaseUrl: String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let key = dict["Masjidi Api Base Url"] as? String else {
            
            fatalError("API Key not found in Info.plist")
        }
        return "https://" + key
    }
}

struct AppInfo {
    static var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    static var build: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    static var fullVersionString: String {
        return "v\(version) (\(build))"
    }
}
