// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import Foundation
import ObjectiveC

private var bundleKey: UInt8 = 0

final class LanguageBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func setLanguage(_ language: AppLanguage) {
        var bundlePath: String?

        switch language {
        case .system:
            bundlePath = nil
        case .english:
            bundlePath = Bundle.main.path(forResource: "en", ofType: "lproj")
        case .simplifiedChinese:
            bundlePath = Bundle.main.path(forResource: "zh-Hans", ofType: "lproj")
        case .traditionalChinese:
            bundlePath = Bundle.main.path(forResource: "zh-Hant", ofType: "lproj")
        }

        object_setClass(Bundle.main, LanguageBundle.self)

        if let path = bundlePath {
            objc_setAssociatedObject(Bundle.main, &bundleKey, path, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("[Language] Set language to: \(language.rawValue), path: \(path)")
        } else {
            let preferredLanguage = Locale.preferredLanguages.first ?? "en"
            var path: String
            if preferredLanguage.hasPrefix("zh-Hant") {
                path = Bundle.main.path(forResource: "zh-Hant", ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj")!
            } else if preferredLanguage.hasPrefix("zh-Hans") || preferredLanguage.hasPrefix("zh-CN") || preferredLanguage.hasPrefix("zh") {
                path = Bundle.main.path(forResource: "zh-Hans", ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj")!
            } else {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")!
            }
            objc_setAssociatedObject(Bundle.main, &bundleKey, path, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("[Language] Set system language, detected: \(preferredLanguage), path: \(path)")
        }

        let testKey = "Finish"
        let testResult = Bundle.main.localizedString(forKey: testKey, value: nil, table: nil)
        print("[Language] Test '\(testKey)' = '\(testResult)'")
    }
}