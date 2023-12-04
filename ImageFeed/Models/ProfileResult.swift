//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Арина Колганова on 27.11.2023.
//

import Foundation

struct ProfileResult: Codable {
    var username: String
    var firstName: String
    var lastName: String
    var bio: String?

    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
