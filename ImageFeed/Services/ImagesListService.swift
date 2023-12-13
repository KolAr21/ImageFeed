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
    private var isDone: Bool = false
    private var taskForLike: URLSessionTask?
    private var lastLoadedPage: Int?
    private let perPage = 10

    func fetchPhotosNextPage() {
        guard !isDone else { return }
        isDone = true
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1

        let request = imageListRequest(page: nextPage, perPage: perPage)
        task?.cancel()
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    self?.photos += photoResults.map { Photo(photoResult: $0) }
                    self?.lastLoadedPage = nextPage + 1
                    self?.isDone = false
                    self?.task = nil
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
                }
            case .failure(let error):
                self?.isDone = false
                self?.task = nil
                print("Error fetch photos: \(error)")
            }
        }
        task?.resume()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        taskForLike?.cancel()
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/\(photoId)/like") ?? Constants.defaultBaseURL)
        request.httpMethod = isLike ? "DELETE" : "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            if let _ = data,
               let response = response,
               let _ = (response as? HTTPURLResponse)?.statusCode
            {
                DispatchQueue.main.async {
                    self.taskForLike = nil
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                       let photo = self.photos[index]
                       let newPhoto = Photo(
                                id: photo.id,
                                size: photo.size,
                                createdAt: photo.createdAt,
                                welcomeDescription: photo.welcomeDescription,
                                fullImageURL: photo.fullImageURL,
                                thumbImageURL: photo.thumbImageURL,
                                largeImageURL: photo.largeImageURL,
                                isLiked: !photo.isLiked
                            )
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
        self.taskForLike = task
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
