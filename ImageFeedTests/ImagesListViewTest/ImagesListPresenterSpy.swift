//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Арина Колганова on 30.12.2023.
//

@testable import ImageFeed
import UIKit

final class ImagesListPresenterSpy: ImagesPresenterProtocol {
    var view: ImageFeed.ImagesViewControllerProtocol?
    var didFetchPhotos: Bool = false

    func viewDidLoad() {
        didFetchPhotos = true
    }

    func fetchPhotosNextPage() {
        view?.photos.append(ImageFeed.Photo(
            id: "1",
            size: CGSize(width: 10, height: 20),
            createdAt: Date(timeIntervalSinceReferenceDate: -123456789.0),
            welcomeDescription: "Hi",
            fullImageURL: "",
            thumbImageURL: "",
            largeImageURL: "",
            isLiked: false
        ))
    }

    func changeLike(photo: ImageFeed.Photo, cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {
        view?.imageListService.changeLike(photoId: photo.id, isLike: photo.isLiked) {_ in
            print()
        }
    }
}
