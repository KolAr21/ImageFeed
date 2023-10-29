//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Арина Колганова on 21.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private var avatarView: UIImageView!
    private var nameLabel: UILabel!
    private var nicknameLabel: UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addAvatarProfile()
        addLogoutButton()
        addNameLabel()
        addNicknameLabel()
        addDescriptionLabel()
    }
    

    private func addAvatarProfile() {
        let avatarImage = UIImage(named: "avatar")
        avatarView = UIImageView(image: avatarImage)

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarView)

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.heightAnchor.constraint(equalToConstant: 70)
        ])

        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 35
    }

    private func addLogoutButton() {
        let imageButton = UIImage(named: "logout_button")
        let logoutButton = UIButton()
        logoutButton.setImage(imageButton, for: .normal)
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])
    }

    @objc
    private func didTapLogoutButton() {}

    private func addNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8)
        ])

        self.nameLabel = nameLabel
    }

    private func addNicknameLabel() {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.textColor = UIColor(named: "YP Gray")
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)

        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)

        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])

        self.nicknameLabel = nicknameLabel
    }

    private func addDescriptionLabel() {
        let descriptionLabel = UILabel()

        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8)
        ])
    }

}
