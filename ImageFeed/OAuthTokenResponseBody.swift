//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Арина Колганова on 13.11.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
