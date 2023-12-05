//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Арина Колганова on 05.12.2023.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []

    private let perPage = 10

    private var lastLoadedPage: Int?
    private var task: URLSessionTask?

    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard task == nil else { return }

        let request = imageListRequest(page: nextPage, perPage: perPage)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            switch result {
            case .success(let body):
                photos.append(Photo(photoResult: body))

            case .failure():
                assertionFailure("error in ImagesListService")
                
            }
        }
    }

    private func imageListRequest(page: Int, perPage: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page=\(perPage)"
            /*+ "&&order_by=\(Constants.redirectURI)"*/,
            httpMethod: "GET",
            baseURL: URL(string: "https://unsplash.com")!
        )

    }
}
