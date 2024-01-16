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
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .autoreverse) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.1) {
                self.likeButton.transform = .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.4) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
                self.likeButton.transform = .identity
            }
        }

        delegate?.didTapLikeList(cell: self)
    }
    
}

extension ImagesListCell {
    func setIsLiked(isLiked: Bool) {
        let imageLike = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.imageView?.image = imageLike
    }
}
