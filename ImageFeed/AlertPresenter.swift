//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Арина Колганова on 02.12.2023.
//
import UIKit

final class AlertPresenter {

    static func showError(alertModel: AlertModel, delegate: UIViewController?) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in
                alertModel.completion?()
            }

        alert.view.accessibilityIdentifier = "Alert"
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}