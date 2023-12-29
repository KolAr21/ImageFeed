//
//  ImagesListViewTest.swift
//  ImageFeedTests
//
//  Created by Арина Колганова on 30.12.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTest: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.didFetchPhotos)
    }

    func testFetchNext() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let image = ImagesListMock()
        let viewController = ImagesListViewControllerSpy(photos: image.photos, imageListService: image)
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.fetchPhotosNextPage()

        //then
        XCTAssertEqual(viewController.photos.count, 2)
    }

    func testDidTappedLikeButton() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let image = ImagesListMock()
        let viewController = ImagesListViewControllerSpy(photos: image.photos, imageListService: image)
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.changeLike(photo: image.photos[0], cell: ImagesListCell(), indexPath: IndexPath())

        //then
        XCTAssertTrue(image.photos[0].isLiked)
    }
}
