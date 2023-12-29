//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Арина Колганова on 21.10.2023.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }

    func updateAvatar(url: URL, placeholder: UIImage)
    func updateProfileDetails(name: String, loginName: String, bio: String)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?

    private var profileImageServiceObserver: NSObjectProtocol?

    lazy private var avatarView: UIImageView = {
        let image = UIImage(named: "avatar")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        return view
    }()

    lazy private var logoutButton: UIButton = {
        let imageButton = UIImage(named: "logout_button")
        let logoutButton = UIButton()
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        logoutButton.setImage(imageButton, for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        return logoutButton
    }()

    lazy private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    lazy private var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.textColor = UIColor(named: "YP Gray")
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nicknameLabel
    }()

    lazy private var descriptionLabel: UILabel = {
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

    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.accessibilityIdentifier = "logoutButton"
        self.restorationIdentifier = "ProfileViewController"

        presenter?.viewDidLoad()

        addAvatarProfile()
        addLogoutButton()
        addNameLabel()
        addNicknameLabel()
        addDescriptionLabel()


        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                presenter?.updateAvatar()
            }
    }

    func updateAvatar(url: URL, placeholder: UIImage) {
        avatarView.kf.setImage(with: url, placeholder: placeholder)
    }

    func updateProfileDetails(name: String, loginName: String, bio: String) {
        nameLabel.text = name
        nicknameLabel.text = loginName
        descriptionLabel.text = bio
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
    private func didTapLogoutButton() {
        let logout = presenter?.logout
        let alertModel = AlertModel(title: "Пока, пока!", message: "Уверены что хотите выйти?", buttonText: ["Да", "Нет"], completion: [logout, nil])
        AlertPresenter.showAlert(alertModel: alertModel, delegate: self)
    }

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
