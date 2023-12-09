//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Арина Колганова on 05.12.2023.
//

import Foundation

class ImagesListService {
    static let DidChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")

    private (set) var photos: [Photo] = []

    private var task: URLSessionTask?
    private var taskForLike: URLSessionTask?
    private var lastLoadedPage: Int?
    private let perPage = 10

    func fetchPhotosNextPage() {
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1

        let request = imageListRequest(page: nextPage, perPage: perPage)

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    self?.task = nil
                    self?.photos += photoResults.map { Photo(photoResult: $0) }
                    self?.lastLoadedPage = nextPage + 1
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
                }
            case .failure(let error):
                print("Error fetch photos: \(error)")
            }
        }
        self.task = task
        task.resume()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        taskForLike?.cancel()
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/\(photoId)/like") ?? Constants.defaultBaseURL)
        request.httpMethod = isLike ? "DELETE" : "POST"
        print("changeLike", isLike)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                DispatchQueue.main.async {
                    self.task = nil
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                       let photo = self.photos[index]
                       let newPhoto = Photo(
                                id: photo.id,
                                size: photo.size,
                                createdAt: photo.createdAt,
                                welcomeDescription: photo.welcomeDescription,
                                thumbImageURL: photo.thumbImageURL,
                                largeImageURL: photo.largeImageURL,
                                isLiked: !photo.isLiked
                            )
                        print("changeLike1", newPhoto.isLiked)
                        self.photos[index] = newPhoto
                        NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
                    }
                    completion(.success(()))
                }
            } else if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
            } else {
                completion(.failure(NetworkError.urlSessionError))
            }
        })
        self.task = task
        task.resume()
    }

    private func imageListRequest(page: Int, perPage: Int) -> URLRequest {
            URLRequest.makeHTTPRequest(
                path: "/photos"
                + "?page=\(page)"
                + "&&per_page=\(perPage)"
                + "&&client_id=\(Constants.accessKey)"
                /*+ "&&order_by=\(Constants.redirectURI)"*/,
                httpMethod: "GET",
                baseURL: Constants.defaultBaseURL
            )

        }
}
