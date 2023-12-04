//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Арина Колганова on 28.11.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?

    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    func setAvatarURL(url: String) {
        avatarURL = url
    }

    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let token = OAuth2TokenStorage().token else { return }
        let request = profileImageTokenRequest(token: token, username: username)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.task = nil
                switch result {
                case .success(let body):
                    self.avatarURL = body.profileImage.small
                    completion(.success(String(self.avatarURL ?? "")))
                case .failure(let error):
                    completion(.failure(error))
                }
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": self.avatarURL])
            }
        }
        self.task = task
        task.resume()
    }

    private func profileImageTokenRequest(token: String, username: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: Constants.defaultBaseURL
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request

    }
}
