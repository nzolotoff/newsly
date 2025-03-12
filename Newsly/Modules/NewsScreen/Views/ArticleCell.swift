//
//  ArticleCell.swift
//  Newsly
//
//  Created by Nikita Zolotov on 08.03.2025.
//

import UIKit

final class ArticleCell: UITableViewCell {
    // MARK: - Constants
    enum Constants {
        enum Spacing {
            static let s: CGFloat = 8
            static let m: CGFloat = 12
            static let l: CGFloat = 16
        }
        
        enum Size {
            static let sourceIconSize: CGFloat = 20
            static let cornerRadius: CGFloat = 12
        }
        
        enum Settings {
            static let numberOfLines: Int = 3
        }
    }
    
    // MARK: - Fields
    static let reuseIdentifier: String = "ArticleCell"
    
    private let wrapView: UIView = UIView()
    private let mainImage: AsyncImageView = AsyncImageView()
    private let sourceIcon: AsyncImageView = AsyncImageView()
    private let sourceName: UILabel = UILabel()
    private let sourceStackView: UIStackView = UIStackView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let contentStack: UIStackView = UIStackView()
    
    // MARK: - Lyfecycle
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.reset()
        sourceIcon.reset()
    }
    
    // MARK: - Cell configuration
    func configure(with model: NewsModel.Article) {
        titleLabel.text = model.title
        descriptionLabel.text = model.announce
        sourceName.text = model.sourceName
        mainImage.loadImage(from: model.image?.url)
        sourceIcon.loadImage(from: model.sourceIcon)
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        self.backgroundColor = .systemGray6
        configureWrapView()
        configureMainImage()
        configureSourceStack()
        configureContentStack()
    }
    
    private func configureWrapView() {
        wrapView.backgroundColor = .white
        wrapView.layer.cornerRadius = Constants.Size.cornerRadius
        
        addSubview(wrapView)
        wrapView.pinHorizontal(to: self, Constants.Spacing.l)
        wrapView.pinVertical(to: self, Constants.Spacing.m)
    }
    
    private func configureMainImage() {
        mainImage.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        mainImage.layer.cornerRadius = Constants.Size.cornerRadius
        mainImage.clipsToBounds = true
        mainImage.contentMode = .scaleAspectFit
        
        wrapView.addSubview(mainImage)
        mainImage.pinHorizontal(to: wrapView)
        mainImage.pinTop(to: wrapView)
    }
    
    private func configureSourceStack() {
        sourceIcon.setWidth(Constants.Size.sourceIconSize)
        sourceIcon.setHeight(Constants.Size.sourceIconSize)
        sourceIcon.layer.cornerRadius = Constants.Size.sourceIconSize / 2
        sourceName.font = .preferredFont(forTextStyle: .caption2)
        sourceName.textColor = .secondaryLabel
        sourceName.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        sourceStackView.axis = .horizontal
        sourceStackView.alignment = .center
        sourceStackView.spacing = Constants.Spacing.s
        
        sourceStackView.addArrangedSubviews(sourceIcon, sourceName)
    }
    
    private func configureContentStack() {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .black
        
        descriptionLabel.font = .preferredFont(forTextStyle: .caption1)
        descriptionLabel.textColor = .secondaryLabel
        
        for label in [titleLabel, descriptionLabel] {
            label.numberOfLines = Constants.Settings.numberOfLines
            label.textAlignment = .left
        }
        
        contentStack.axis = .vertical
        contentStack.spacing = Constants.Spacing.s
        contentStack.addArrangedSubviews(
            sourceStackView,
            titleLabel,
            descriptionLabel
        )
        
        wrapView.addSubview(contentStack)
        contentStack.pinTop(to: mainImage.bottomAnchor, Constants.Spacing.m)
        contentStack.pinHorizontal(to: wrapView, Constants.Spacing.m)
        contentStack.pinBottom(to: wrapView, Constants.Spacing.m)
    }
}
