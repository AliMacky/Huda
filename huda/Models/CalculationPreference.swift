//
//  CalculationPreference.swift
//  huda_new
//
//  Created by Ali Macky on 11/30/25.
//

import Foundation
import Adhan

enum CalculationPreference: String, CaseIterable, Identifiable {
    case dubai
    case egyptian
    case karachi
    case kuwait
    case msc
    case mwl
    case na
    case qatar
    case singapore
    case tehran
    case turkey
    case uq
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .dubai: return "Dubai"
        case .egyptian: return "Egyptian"
        case .karachi: return "Karachi"
        case .kuwait: return "Kuwait"
        case .msc: return "Moonsighting Committee"
        case .mwl: return "Muslim World League"
        case .na: return "North America"
        case .qatar: return "Qatar"
        case .singapore: return "Singapore"
        case .tehran: return "Tehran"
        case .turkey: return "Turkey"
        case .uq: return "Umm Al-Qura"
        }
    }
    
    var packageValue: CalculationMethod {
        switch self {
        case .dubai: return .dubai
        case .egyptian: return .egyptian
        case .karachi: return .karachi
        case .kuwait: return .kuwait
        case .msc: return .moonsightingCommittee
        case .mwl: return .muslimWorldLeague
        case .na: return .northAmerica
        case .qatar: return .qatar
        case .singapore: return .singapore
        case .tehran: return .tehran
        case .turkey: return .turkey
        case .uq: return .ummAlQura
        }
    }
}
