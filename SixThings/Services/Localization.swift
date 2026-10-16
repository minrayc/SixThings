//
//  Localization.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/17.
//
import Foundation

func localized(_ key: String) -> String {
    let language = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
    guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
          let bundle = Bundle(path: path) else {
        return key
    }
    return bundle.localizedString(forKey: key, value: nil, table: nil)
}
