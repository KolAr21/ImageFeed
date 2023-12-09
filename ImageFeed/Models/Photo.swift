//
//  Photo.swift
//  ImageFeed
//
//  Created by Арина Колганова on 05.12.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool

    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = Date.convertStringToDate(date: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
    
    init(id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, thumbImageURL: String, largeImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}
