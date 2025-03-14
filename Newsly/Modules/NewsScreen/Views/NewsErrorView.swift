//
//  NewsErrorView.swift
//  Newsly
//
//  Created by Nikita Zolotov on 14.03.2025.
//

import Foundation
import UIKit

final class NewsErrorView: UIView {
    // MARK: - Constants
    enum Constants {
        enum IconImageView {
            static let defaultImg: UIImage? = UIImage(systemName: "exclamationmark.icloud")
            static let topOffset: CGFloat = 52
            static let horizontalOffset: CGFloat = 121
            static let height: CGFloat = 160
            static let width: CGFloat = 160
        }
        
        enum TitleLabel {
            static let lines: Int = 0
            static let topOffset: CGFloat = 24
            static let horizontalOffset: CGFloat = 52
        }
        
        enum TryAgainButton {
            static let title: String = "Try again"
            static let topOffset: CGFloat = 24
            static let horizontalOffset: CGFloat = 20
            static let height: CGFloat = 48
            static let corner: CGFloat = 12
        }
    }
    
    // MARK: - Fields
    private let iconImageView: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    private var tryAgainButton: UIButton = UIButton(type: .system)
    
    var buttonAction: (() -> Void)?
    
    // MARK: - Lyfecycle
    init(
        icon: UIImage? = Constants.IconImageView.defaultImg,
        title: String
    ) {
        super.init(frame: .zero)
        configureUI(icon, title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update description
    func updateDescription(with text: String) {
        titleLabel.text = text
    }
    // MARK: - Configure UI
    private func configureUI(
        _ icon: UIImage?,
        _ title: String
    ) {
        configureIconImageView(icon)
        configureTitleLabel(title)
        configureTryAgainButton()
    }
    
    private func configureIconImageView(_ image: UIImage?) {
        iconImageView.image = image
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemGray2
        
        addSubview(iconImageView)
        iconImageView.pinTop(to: self, Constants.IconImageView.topOffset)
        iconImageView.pinHorizontal(to: self, Constants.IconImageView.horizontalOffset)
        iconImageView.setWidth(Constants.IconImageView.width)
        iconImageView.setHeight(Constants.IconImageView.height)
    }
    
    private func configureTitleLabel(_ text: String) {
        titleLabel.text = text
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = Constants.TitleLabel.lines
        
        addSubview(titleLabel)
        titleLabel.pinTop(
            to: iconImageView.bottomAnchor,
            Constants.TitleLabel.topOffset
        )
        titleLabel.pinHorizontal(
            to: self,
            Constants.TitleLabel.horizontalOffset
        )
    }
    
    private func configureTryAgainButton() {
        tryAgainButton.setTitle(
            Constants.TryAgainButton.title,
            for: .normal
        )
        tryAgainButton.layer.cornerRadius = Constants.TryAgainButton.corner
        tryAgainButton.setTitleColor(.white, for: .normal)
        tryAgainButton.backgroundColor = .black
        tryAgainButton.addTarget(
            self,
            action: #selector(tryAgainButtonWasTapped),
            for: .touchUpInside
        )
        addSubview(tryAgainButton)
        tryAgainButton.pinTop(
            to: titleLabel.bottomAnchor,
            Constants.TryAgainButton.topOffset
        )
        tryAgainButton.pinHorizontal(
            to: self,
            Constants.TryAgainButton.horizontalOffset
        )
        tryAgainButton.setHeight(Constants.TryAgainButton.height)
    }
    
    // MARK: - Actions
    @objc private func tryAgainButtonWasTapped() {
        buttonAction?()
    }
}
