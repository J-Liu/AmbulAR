// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu
// Licensed under AGPL-3.0-or-later with an additional permission
// under Section 7. See LICENSE for details.

import UIKit

enum AppTheme: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"

    var localizedName: String {
        switch self {
        case .system: return NSLocalizedString("System Default", comment: "")
        case .light: return NSLocalizedString("Light", comment: "")
        case .dark: return NSLocalizedString("Dark", comment: "")
        }
    }

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }

    static var current: AppTheme {
        if let saved = UserDefaults.standard.string(forKey: "AppTheme"),
           let theme = AppTheme(rawValue: saved) {
            return theme
        }
        return .system
    }

    func apply() {
        UserDefaults.standard.set(rawValue, forKey: "AppTheme")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
    }
}
