//
//  Constants.swift
//  ImageFeed
//
//  Created by Арина Колганова on 15.01.2024.
//

import Foundation

enum Constants {
    static let accessKey = "Wa1xvKOYkQ-TGeXLtZ2AUgtqdLxSj6rRryXk0nZMiKw"
    static let secretKey = "33nl4tyfD1GfAK2os5r43WzholUh7MFx5n2MGO-sfb0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}
