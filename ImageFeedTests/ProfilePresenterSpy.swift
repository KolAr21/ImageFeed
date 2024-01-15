//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Арина Колганова on 29.12.2023.
//

import ImageFeed
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var logoutDidTapped: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
        updateAvatar()
        updateProfileDetailsPresenter()
    }

    func updateAvatar() {
        view?.updateAvatar(url: URL(fileURLWithPath: ""), placeholder: UIImage())
    }

    func updateProfileDetailsPresenter() {
        view?.updateProfileDetails(name: "", loginName: "", bio: "")
    }

    func logout() {
        logoutDidTapped = true
    }

}
