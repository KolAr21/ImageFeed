//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Арина Колганова on 27.11.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?

    func setProfile(profile: Profile) {
        self.profile = profile
    }

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        let request = profileTokenRequest(token: token)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                self?.task = nil
                switch result {
                case .success(let body):
                    completion(.success(Profile(username: body.username, name: "\(body.firstName) \(body.lastName)", bio: body.bio)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }

    private func profileTokenRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: Constants.defaultBaseURL
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request

    }
}
