//
//  File.swift
//  ImageFeed
//
//  Created by Арина Колганова on 17.11.2023.
//
import WebKit
import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    var token: String? {
        set {
            KeychainWrapper.standard.set(newValue!, forKey: "Auth token")
        }
        get {
            KeychainWrapper.standard.string(forKey: "Auth token")
        }
    }

    static func clean() {
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }

    static func removeToken() {
        KeychainWrapper.standard.remove(forKey: "Auth token")
    }
}
