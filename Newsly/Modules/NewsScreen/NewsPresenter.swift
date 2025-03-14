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
            return
        }
        
        view?.displayArticlePage(pageURL)
    }
    
    func presentAticleSharingInfo(
        for article: NewsModel.Article,
        shareURL: URL?
    ) {
        let stringURL = String(describing: shareURL)
        let content = "\(article.title)\n\(article.announce)\n\(stringURL)"
        view?.displaySharingInfo(with: content)
    }
}

// MARK: - NewsRoutingLogic
extension NewsPresenter: NewsRoutingLogic {
    func routeTo() {
    }
}
