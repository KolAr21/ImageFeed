//
//  GradientView.swift
//  ImageFeed
//
//  Created by Арина Колганова on 13.10.2023.
//

import UIKit

final class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    private let startColor: UIColor = UIColor(named: "YP Black")?.withAlphaComponent(0) ?? .black.withAlphaComponent(0)
    private var endColor: UIColor = UIColor(named: "YP Black")?.withAlphaComponent(0.2) ?? .black.withAlphaComponent(0.2)
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
}
