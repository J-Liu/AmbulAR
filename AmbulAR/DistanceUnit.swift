// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import Foundation

enum DistanceUnit: String, CaseIterable {
    case meters = "m"
    case kilometers = "km"
    case feet = "ft"

    var title: String {
        switch self {
        case .meters: return "Meters"
        case .kilometers: return "Kilometers"
        case .feet: return "Feet"
        }
    }

    var localizedName: String {
        switch self {
        case .meters: return NSLocalizedString("Meters", comment: "")
        case .kilometers: return NSLocalizedString("Kilometers", comment: "")
        case .feet: return NSLocalizedString("Feet", comment: "")
        }
    }

    func format(_ meters: Float) -> String {
        switch self {
        case .meters:
            return String(format: "%.3f m", meters)
        case .kilometers:
            return String(format: "%.3f km", meters / 1000)
        case .feet:
            return String(format: "%.1f ft", meters * 3.28084)
        }
    }
}