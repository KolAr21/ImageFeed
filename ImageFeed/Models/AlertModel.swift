//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Арина Колганова on 02.12.2023.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: [String] = []
    var completion: [(() -> ())?] = []
}
