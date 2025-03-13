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
    
    func presentArticlePage(with url: URL?) {
        guard let pageURL = url else {
            // alert | error state
            print("!")
            return
        }
        
        view?.displayArticlePage(pageURL)
    }
}

// MARK: - NewsRoutingLogic
extension NewsPresenter: NewsRoutingLogic {
    func routeTo() {
    }
}
