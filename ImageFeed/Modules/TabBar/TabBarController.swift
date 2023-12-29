//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Арина Колганова on 01.12.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImageListViewController"
        )
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(named: "tab_editorial_active"),
                                                           selectedImage: nil)

        let profileViewController = ProfileViewController()
        profileViewController.configure(ProfilePresenter())
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )

        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

