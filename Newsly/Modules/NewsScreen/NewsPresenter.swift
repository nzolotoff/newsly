//
//  NewsPresenter.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//

import Foundation

final class NewsPresenter: NewsPresentationLogic {
    // MARK: - Variables
    weak var view: NewsViewController?
    
    // MARK: - Methods
    func presentStart() {
        view?.displayStart()
    }
}

// MARK: - NewsRoutingLogic
extension NewsPresenter: NewsRoutingLogic {
    func routeTo() {
    }
}
