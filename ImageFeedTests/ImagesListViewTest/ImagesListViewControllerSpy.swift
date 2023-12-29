//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Арина Колганова on 30.12.2023.
//

@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesViewControllerProtocol {
    var photos: [ImageFeed.Photo] = []
    var imageListService: ImageFeed.ImagesListServiceProtocol
    var presenter: ImageFeed.ImagesPresenterProtocol?

    init(presenter: ImageFeed.ImagesPresenterProtocol? = nil, photos: [ImageFeed.Photo], imageListService: ImageFeed.ImagesListServiceProtocol) {
        self.presenter = presenter
        self.photos = photos
        self.imageListService = imageListService
    }

}
