//
//  AsyncImageView.swift
//  Newsly
//
//  Created by Nikita Zolotov on 08.03.2025.
//

import UIKit

final class AsyncImageView: UIView {
    // MARK: - Constants
    enum Constants {
        static let errorImage: UIImage? = UIImage(
            systemName: "exclamationmark.triangle",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 44,
                weight: .medium
            )
        )
    }
    
    // MARK: - Fields
    private let shimmerView: ShimmerView = ShimmerView()
    private let imageView: UIImageView = UIImageView()
    private let errorImage: UIImage? = Constants.errorImage
    
    private var currentLoadingURL: URL?
    
    // MARK: - Lyfecycle
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(from url: URL?) {
        shimmerView.startAnimating()
        currentLoadingURL = url
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard
                let url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                return
            }
            
            // TODO: Fix race condition - add current loading url
            DispatchQueue.main.async { [weak self] in
                if ((self?.currentLoadingURL) != nil), self?.currentLoadingURL == url {
                    self?.imageView.image = image
                    self?.shimmerView.stopAnimating()
                    self?.shimmerView.isHidden = true
                }
            }
        }
    }
    
    func reset() {
        shimmerView.startAnimating()
        shimmerView.isHidden = false
        imageView.image = nil
        currentLoadingURL = nil
        
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        imageView.pin(to: self)
        
        shimmerView.clipsToBounds = true
        addSubview(shimmerView)
        shimmerView.pin(to: self)
    }
}
