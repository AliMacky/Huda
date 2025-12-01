//
//  SettingsManager.swift
//  huda
//
//  Created by Ali Macky on 11/30/25.
//

import Foundation
import Adhan

@Observable
class SettingsManager {
    static let shared = SettingsManager()
    
    var selectedMethod: CalculationMethod {
        get {
            if let raw = UserDefaults.standard.string(forKey: "calc_method"),
               let method = CalculationMethod(rawValue: raw) {
                return method
            }
            
            // Default Value
            return .northAmerica
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "calc_method")
        }
    }
    
    var selectedAsrMadhab: MadhabPreference {
        get {
            if let raw = UserDefaults.standard.string(forKey: "madhab_pref"),
               let method = MadhabPreference(rawValue: raw) {
                return method
            }
            
            // Default Value
            return .shafi
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "madhab_pref")
        }
    }
    
    var selectedMosque: MosqueSearchResults? {
            get {
                guard let data = UserDefaults.standard.data(forKey: "user_mosque") else { return nil }
                if let decoded = try? JSONDecoder().decode(MosqueSearchResults.self, from: data) {
                    return decoded
                }
                return nil
            }
            set {
                if let newValue = newValue {
                    if let encoded = try? JSONEncoder().encode(newValue) {
                        UserDefaults.standard.set(encoded, forKey: "user_mosque")
                    }
                } else {
                    UserDefaults.standard.removeObject(forKey: "user_mosque")
                }
            }
        }
}
