//
//  ProfileViewTest.swift
//  ImageFeedTests
//
//  Created by Арина Колганова on 29.12.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        profileViewController.configure(presenter)

        //when
        _ = profileViewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testViewControllerCallsUpdateAvatarAndProfile() {
        //given
        let profileViewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        profileViewController.presenter = presenter
        presenter.view = profileViewController

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(profileViewController.viewDidUpdateAvatar)
        XCTAssertTrue(profileViewController.viewDidUpdateProfile)
    }

    func testViewControllerLogout() {
        //given
        let profileViewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        profileViewController.presenter = presenter
        presenter.view = profileViewController

        //when
        presenter.logout()

        //then
        XCTAssertTrue(presenter.logoutDidTapped)
    }
}
