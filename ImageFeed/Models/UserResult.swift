//
//  UserResult.swift
//  ImageFeed
//
//  Created by Арина Колганова on 28.11.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}
