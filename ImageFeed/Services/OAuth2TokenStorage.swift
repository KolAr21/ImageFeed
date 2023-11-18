//
//  File.swift
//  ImageFeed
//
//  Created by Арина Колганова on 17.11.2023.
//

import Foundation

class OAuth2TokenStorage {
    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "BearerToken")
        }
        get {
            UserDefaults.standard.string(forKey: "BearerToken")
        }
    }
}
