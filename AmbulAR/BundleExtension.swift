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
        let result = bundle.localizedString(forKey: key, value: value, table: tableName)
        print("[Language] Key: '\(key)' -> '\(result)' (bundle: \(path))")
        return result
    }
}

extension Bundle {
    static func setLanguage(_ language: AppLanguage) {
        object_setClass(Bundle.main, LanguageBundle.self)

        let bundlePath: String?
        
        switch language {
        case .system:
            let preferredLanguage = Locale.preferredLanguages.first ?? "en"
            if preferredLanguage.hasPrefix("zh-Hant") {
                bundlePath = Bundle.main.path(forResource: "zh-Hant", ofType: "lproj")
            } else if preferredLanguage.hasPrefix("zh-Hans") || preferredLanguage.hasPrefix("zh-CN") || preferredLanguage.hasPrefix("zh") {
                bundlePath = Bundle.main.path(forResource: "zh-Hans", ofType: "lproj")
            } else {
                bundlePath = Bundle.main.path(forResource: "en", ofType: "lproj")
            }
        case .english:
            bundlePath = Bundle.main.path(forResource: "en", ofType: "lproj")
        case .simplifiedChinese:
            bundlePath = Bundle.main.path(forResource: "zh-Hans", ofType: "lproj")
        case .traditionalChinese:
            bundlePath = Bundle.main.path(forResource: "zh-Hant", ofType: "lproj")
        }

        if let path = bundlePath {
            objc_setAssociatedObject(Bundle.main, &bundleKey, path, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            let fallback = Bundle.main.path(forResource: "en", ofType: "lproj") ?? ""
            objc_setAssociatedObject(Bundle.main, &bundleKey, fallback, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}