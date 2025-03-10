//
//  ShimmerView.swift
//  Newsly
//
//  Created by Nikita Zolotov on 08.03.2025.
//

import UIKit

final class ShimmerView: UIView {
    // MARK: - Constants
    enum Constants {
        
    }
    
    // MARK: - Fields
    
    
    // MARK: - Lyfecycle
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        backgroundColor = .black
    }
}
