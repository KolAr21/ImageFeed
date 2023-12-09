//
//  ViewController.swift
//  ImageFeed
//
//  Created by Арина Колганова on 07.10.2023.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerDelegate {
    func didTapLikeList(cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController {

    private var imageListServiceObserver: NSObjectProtocol?

    @IBOutlet private var tableView: UITableView!

    private var imageListService = ImagesListService()
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        imageListService.fetchPhotosNextPage()

        imageListServiceObserver = NotificationCenter.default.addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                //print(photos.count)
                print("ImagesListService.DidChangeNotification")
                self.updateTableViewAnimated()
            }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.imageView.kf.setImage(with: URL(string: photos[indexPath.row].thumbImageURL))
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private func updateTableViewAnimated() {
        DispatchQueue.main.async {
            let oldCount = self.photos.count
            let newCount = self.imageListService.photos.count
            self.photos = self.imageListService.photos
            print(self.photos.count)
            self.tableView.performBatchUpdates({
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            })
            print(self.photos.count)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tb", photos.count)
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        cell.imageCell.kf.indicatorType = .activity
        let imageFromPhotos = photos[indexPath.row].thumbImageURL
        cell.imageCell.kf.setImage(with: URL(string: imageFromPhotos), placeholder: UIImage(named: "placeholder_image_cell"))
        
        cell.dateLabel.text = dateFormatter.string(from: Date())

//        let isLike = indexPath.row % 2 == 0
//        let imageLike = isLike ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
//        cell.likeButton.imageView?.image = imageLike
        let imageLike = photos[indexPath.row].isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.imageView?.image = imageLike
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width //image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = tableView.numberOfRows(inSection: 0) - 1
        if lastIndex == indexPath.row {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListViewControllerDelegate {
    func didTapLikeList(cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        print("ImagesListViewController", photos[indexPath.row].isLiked)
        imageListService.changeLike(photoId: photos[indexPath.row].id, isLike: photos[indexPath.row].isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                print("LOH")
                self.photos = self.imageListService.photos
                let imageLike = self.photos[indexPath.row].isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
                cell.likeButton.imageView?.image = imageLike
                print("Last", self.photos[indexPath.row].isLiked)
            case .failure(let error):
                print("didTapLikeList error: \(error)")
            }
        }
    }
}
