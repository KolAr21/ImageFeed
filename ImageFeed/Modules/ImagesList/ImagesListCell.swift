//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Арина Колганова on 12.10.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!

    var delegate: ImagesListViewController?

    override func prepareForReuse() {
        imageCell.kf.cancelDownloadTask()
    }

    @IBAction private func didTapLike() {
        delegate?.didTapLikeList(cell: self)
    }
    
}
