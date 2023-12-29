//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Арина Колганова on 29.12.2023.
//

import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var viewDidUpdateAvatar: Bool = false
    var viewDidUpdateProfile: Bool = false

    func updateAvatar(url: URL, placeholder: UIImage) {
        viewDidUpdateAvatar = true
    }

    func updateProfileDetails(name: String, loginName: String, bio: String) {
        viewDidUpdateProfile = true
    }
}
