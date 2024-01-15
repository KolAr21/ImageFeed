//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Арина Колганова on 10.11.2023.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    static var standard: AuthConfiguration {
            return AuthConfiguration(
                accessKey: "Wa1xvKOYkQ-TGeXLtZ2AUgtqdLxSj6rRryXk0nZMiKw",
                secretKey: "33nl4tyfD1GfAK2os5r43WzholUh7MFx5n2MGO-sfb0",
                redirectURI: "urn:ietf:wg:oauth:2.0:oob",
                accessScope: "public+read_user+write_likes",
                defaultBaseURL: URL(string: "https://api.unsplash.com")!,
                authURLString: "https://unsplash.com/oauth/authorize"
            )
        }
}
