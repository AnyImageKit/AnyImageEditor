//
//  BundleHelper.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject. All rights reserved.
//

import UIKit

struct BundleHelper {
    
    static var bundle = Bundle(for: ImageEditorController.self)
    static private var _languageBundle: Bundle?
    
    static var languageBundle: Bundle? {
        if _languageBundle == nil {
            var language = (Locale.preferredLanguages.first ?? "en") as NSString
            if language.hasPrefix("zh") {
                if language.range(of: "Hans").location != NSNotFound {
                    language = "zh-Hans"
                } else {
                    language = "zh-Hant"
                }
            }
            _languageBundle = Bundle(path: bundle.path(forResource: language as String, ofType: "lproj") ?? "")
        }
        return _languageBundle
    }
    
    static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
    
    static func localizedString(key: String) -> String {
        return localizedString(key: key, value: nil)
    }
    
    static func localizedString(key: String, value: String?) -> String {
        var value = value
        value = languageBundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}

