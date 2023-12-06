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

    override func prepareForReuse() {
        imageCell.kf.cancelDownloadTask()
    }
    
}
