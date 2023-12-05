//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Арина Колганова on 05.12.2023.
//

//import Foundation
//
//final class ImagesListService {
//    private (set) var photos: [Photo] = []
//
//    private let perPage = 10
//    private let urlSession = URLSession.shared
//
//    private var lastLoadedPage: Int?
//    private var task: URLSessionTask?
//
//    func fetchPhotosNextPage() {
//        var nextPage: Int
//                if let lastLoadedPage = lastLoadedPage {
//                    nextPage = lastLoadedPage + 1
//                } else { nextPage = 1 }
////        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
////        guard task == nil else { return }
//
////        let request = imageListRequest(page: nextPage, perPage: perPage)
//        let baseURL = URL(string: "\(Constants.defaultBaseURL)")!
//        let photosURL = baseURL.appendingPathComponent("photos")
//
//        var components = URLComponents(url: photosURL, resolvingAgainstBaseURL: true)
//        components?.queryItems = [
//            "page": "\(nextPage)",
//            "per_page": "10",
//            "order_by": "latest",
//            "client_id": Constants.accessKey
//        ].compactMap { URLQueryItem(name: $0.key, value: $0.value) }
//
//        guard let url = components?.url else { return}
//
//        let request = URLRequest(url: url)
//        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
//            guard let self = self else { return }
//            self.task = nil
//            switch result {
//            case .success(let photoResults):
//                let newPhotos = photoResults.map { Photo(photoResult: $0) }
//                DispatchQueue.main.async {
//                    self.photos.append(contentsOf: newPhotos)
//                    // Увеличиваем номер следующей страницы для закачки.
//                    nextPage += 1
//                    // Публикуем нотификацию об изменении данных.
//                    //NotificationCenter.default.post(name: Self.DidChangeNotification, object: nil)
//                }
////            case .success(let body):
////                print(body)
////                DispatchQueue.main.async {
////                    lastLoadedPage = nextPage
////                    photos += body.map { Photo(photoResult: $0) }
////                }
//
//            case .failure():
//                assertionFailure("error in ImagesListService")
//                return
//
//            }
//        }
//        task.resume()
//    }
//
//    private func imageListRequest(page: Int, perPage: Int) -> URLRequest {
//        URLRequest.makeHTTPRequest(
//            path: "/photos"
//            + "?page=\(page)"
//            + "&&per_page=\(perPage)"
//            /*+ "&&order_by=\(Constants.redirectURI)"*/,
//            httpMethod: "GET",
//            baseURL: Constants.defaultBaseURL
//        )
//
//    }
//}

import Foundation

class ImagesListService {
    private (set) var photos: [Photo] = []

    private var lastLoadedPage: Int?
    private let perPage = 10

    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1

        let request = imageListRequest(page: nextPage, perPage: perPage)

        let task = URLSession.shared.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    self.photos += photoResults.map { Photo(photoResult: $0) }
                    self.lastLoadedPage = nextPage + 1
                }
            case .failure(let error):
                print("Error fetching photos: \(error)")
            }
        }
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
