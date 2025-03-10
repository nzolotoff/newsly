//
//  UIStackView+.swift
//  HealthyWeather
//
//  Created by Grigory Sosnovskiy on 06.08.2024.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }

    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }
}
