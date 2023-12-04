//
//  Profile.swift
//  ImageFeed
//
//  Created by Арина Колганова on 27.11.2023.
//

import Foundation

struct Profile {
    var username: String
    var name: String
    var loginName: String {
        "@\(username)"
    }
    var bio: String?
}
