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

protocol ImagesViewControllerProtocol: AnyObject {
    var presenter: ImagesPresenterProtocol? { get set }
    var photos: [Photo] { get set }
    var imageListService: ImagesListServiceProtocol { get set }
}

final class ImagesListViewController: UIViewController & ImagesViewControllerProtocol {
    var presenter: ImagesPresenterProtocol?
    var photos: [Photo] = []

    private var imageListServiceObserver: NSObjectProtocol?

    @IBOutlet private var tableView: UITableView!

    var imageListService: ImagesListServiceProtocol = ImagesListService()
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        presenter = ImagesPresenter(view: self, imageListService: imageListService)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        presenter?.fetchPhotosNextPage()

        imageListServiceObserver = NotificationCenter.default.addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.fullImageURL = URL(string: photos[indexPath.row].fullImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private func updateTableViewAnimated() {
        DispatchQueue.main.async {
            let oldCount = self.photos.count
            let newCount = self.imageListService.photos.count
            self.tableView.performBatchUpdates({
                self.photos = self.imageListService.photos
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            })
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
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

        if let date = photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        cell.setIsLiked(isLiked: photos[indexPath.row].isLiked)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
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
            presenter?.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListViewControllerDelegate {
    func didTapLikeList(cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        presenter?.changeLike(photo: photo, cell: cell, indexPath: indexPath)
    }
}
