//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Арина Колганова on 18.11.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let imageView: UIImageView = {
        UIImageView(image: UIImage(named: "screen_logo"))
    }()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    private let showAuthViewSegueIdentifier = "ShowAuthView"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createSplashScreen()

        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
            switchToTabBarController()
        } else {
            presentAuthViewController()
        }
    }

    private func createSplashScreen() {
        view.backgroundColor = UIColor(named: "YP Black")

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.heightAnchor.constraint(equalToConstant: 77.679)
        ])
    }

    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }

    private func switchToTabBarController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid Configuration")
                return
            }
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarController")
            window.rootViewController = tabBarController
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                guard let token = OAuth2TokenStorage().token else { return }
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                AlertPresenter.showError(alertModel: AlertModel(completion: nil), delegate: self)
            }
        }
    }
}

extension SplashViewController {
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                self.profileService.setProfile(profile: profile)
                let username = profile.username
                self.profileImageService.fetchProfileImageURL(username: username) { imageResult in
                    switch imageResult {
                    case .success(let url):
                        self.profileImageService.setAvatarURL(url: url)
                        NotificationCenter.default.post(
                            name: ProfileImageService.DidChangeNotification,
                            object: self,
                            userInfo: ["URL": url]
                        )
                    case .failure:
                        AlertPresenter.showError(alertModel: AlertModel(completion: nil), delegate: self)
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                UIBlockingProgressHUD.dismiss()
                AlertPresenter.showError(alertModel: AlertModel(completion: nil), delegate: self)
                break
            }
        }
    }

}
