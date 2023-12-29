//
//  ImagesListMock.swift
//  ImageFeedTests
//
//  Created by Арина Колганова on 30.12.2023.
//

@testable import ImageFeed
import Foundation

class ImagesListMock: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = [ImageFeed.Photo(
        id: "1",
        size: CGSize(width: 10, height: 20),
        createdAt: Date(timeIntervalSinceReferenceDate: -123456789.0),
        welcomeDescription: "Hi",
        fullImageURL: "",
        thumbImageURL: "",
        largeImageURL: "",
        isLiked: false
    )]

    func fetchPhotosNextPage() {

    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
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
        }
    }
}
