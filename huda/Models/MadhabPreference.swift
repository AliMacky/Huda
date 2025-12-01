//
//  MadhabPreference.swift
//  huda_new
//
//  Created by Ali Macky on 11/30/25.
//

import Foundation
import Adhan

enum MadhabPreference: String, CaseIterable, Identifiable {
    case shafi
    case hanafi
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .shafi: return "Standard (Shafi, Maliki, Hanbali)"
        case .hanafi: return "Hanafi"
        }
    }

    var packageValue: Madhab {
        switch self {
        case .shafi: return .shafi
        case .hanafi: return .hanafi
        }
    }
}
