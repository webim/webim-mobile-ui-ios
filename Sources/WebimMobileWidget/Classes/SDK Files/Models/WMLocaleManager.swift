//
//  WMLocaleManager.swift
//  WebimMobileWidget
//
//  Created by Anna Frolova on 14.12.2023.
//

import Foundation

public class WMLocaleManager {
    
    init() {}
    
    static func getLocale() -> String {
        
        var locale: String
        
        if #available(iOS 16, *) {
            locale = NSLocale.autoupdatingCurrent.language.languageCode?.identifier ?? "en"
        } else {
            locale = NSLocale.current.languageCode ?? "en"
        }
        
        if locale.starts(with: "uk") {
            locale = "ua"
        }
        
        return locale
    }
    
    public static func isRightOrientationLocale() -> Bool {
        let locale = self.getLocale()
        return locale == "ar" || locale == "he"
    }
    
}
