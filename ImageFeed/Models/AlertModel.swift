//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Арина Колганова on 02.12.2023.
//

import Foundation

struct AlertModel {
    var title: String = "Что-то пошло не так"
    var message: String = "Не удалось войти в систему"
    var buttonText: String = "Ок"
    var completion: (() -> ())?
}
