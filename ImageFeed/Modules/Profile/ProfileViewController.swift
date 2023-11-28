//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Арина Колганова on 21.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

//    private let profileService = ProfileService.shared

    private var avatarView: UIImageView = {
        let image = UIImage(named: "avatar")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        return view
    }()

    private var logoutButton: UIButton = {
        let imageButton = UIImage(named: "logout_button")
        let logoutButton = UIButton()
        logoutButton.setImage(imageButton, for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        return logoutButton
    }()

    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.textColor = UIColor(named: "YP Gray")
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nicknameLabel
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = UIColor(named: "YP White")
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
//        profileService.fetchProfile(OAuth2TokenStorage().token ?? "") { result in
//            switch result {
//            case .success(let body):
//                self.nameLabel.text = body.name
//                self.nicknameLabel.text = body.loginName
//                self.descriptionLabel.text = body.bio
//            case .failure(let error):
//                print(error.localizedDescription)
//                fatalError("error in profile")
//            }
//        }
    }
    

    private func addAvatarProfile() {
        view.addSubview(avatarView)

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func addLogoutButton() {
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])
    }

    @objc
    private func didTapLogoutButton() {}

    private func addNameLabel() {
        view.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8)
        ])
    }

    private func addNicknameLabel() {
        view.addSubview(nicknameLabel)

        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }

    private func addDescriptionLabel() {
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8)
        ])
    }

}
