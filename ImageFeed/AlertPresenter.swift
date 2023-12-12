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
        alertModel.buttonText.enumerated().forEach { ind, textButton in
            let action = UIAlertAction(
                title: textButton,
                style: .default) { _ in
                    alertModel.completion[ind]?()
                }
            alert.addAction(action)
        }
        alert.view.accessibilityIdentifier = "Alert"
        delegate?.present(alert, animated: true, completion: nil)
    }
}
