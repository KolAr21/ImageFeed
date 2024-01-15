//
//  ImagesPresenter.swift
//  ImageFeed
//
//  Created by Арина Колганова on 26.12.2023.
//

import UIKit

protocol ImagesPresenterProtocol {
    var view: ImagesViewControllerProtocol? { get set }

    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photo: Photo, cell: ImagesListCell, indexPath: IndexPath)
}

final class ImagesPresenter: ImagesPresenterProtocol {
    weak var view: ImagesViewControllerProtocol?

    private var imageListService: ImagesListServiceProtocol

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        return dateFormatter
    }()

    init(view: ImagesViewControllerProtocol? = nil, imageListService: ImagesListServiceProtocol) {
        self.view = view
        self.imageListService = imageListService
    }

    func fetchPhotosNextPage() {
        view?.imageListService.fetchPhotosNextPage()
    }

    func changeLike(photo: Photo, cell: ImagesListCell, indexPath: IndexPath) {
        view?.imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                view?.photos = imageListService.photos
                cell.setIsLiked(isLiked: view?.photos[indexPath.row].isLiked ?? false)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print("didTapLikeList error: \(error)")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
