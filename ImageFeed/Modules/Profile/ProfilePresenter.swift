//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Арина Колганова on 26.12.2023.
//

import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }

    func viewDidLoad()
    func updateAvatar()
    func updateProfileDetailsPresenter()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    private let profileService = ProfileService.shared

    init(view: ProfileViewControllerProtocol? = nil) {
        self.view = view
    }

    func viewDidLoad() {
        updateAvatar()
        updateProfileDetailsPresenter()
    }

    func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL, let url = URL(string: profileImageURL) else {
            return
        }
        view?.updateAvatar(url: url, placeholder: UIImage(named: "avatar")!)
    }

    func updateProfileDetailsPresenter() {
        guard let profile = profileService.profile else {
            return
        }
        view?.updateProfileDetails(name: profile.name, loginName: profile.loginName, bio: profile.bio ?? "")
    }

    func logout() {
        WebData.clean()
        OAuth2TokenStorage.removeToken()
        self.switchToSplashViewController()
    }

    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
