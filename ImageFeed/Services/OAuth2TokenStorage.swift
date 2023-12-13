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

    static func removeToken() {
        KeychainWrapper.standard.remove(forKey: "Auth token")
    }
}
