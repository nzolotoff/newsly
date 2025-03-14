//
//  NewsProtocols.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//
import UIKit

protocol NewsBusinessLogic: UITableViewDataSource {
    func loadStart()
    func loadMoreNews()
    func refresh(_ request: NewsModel.FetchRequest)
    func loadArticlePage(with index: Int)
    func loadArticleSharing(for index: Int)
}

protocol NewsDataStore {
    var articles: [NewsModel.Article] { get }
}

protocol NewsPresentationLogic {
    func presentStart()
    func presentArticlePage(with url: URL?)
    func presentAticleSharingInfo(for article: NewsModel.Article, shareURL: URL?)
    func presentErrorState(with error: Error)
}

protocol NewsRoutingLogic {
    func routeTo()
}

protocol NewsWorkerLogic {
    func fetchNews(
        for request: NewsModel.FetchRequest,
        completion: ((Result<NewsResponseDTO, Error>) -> Void)?
    )
}

protocol NewsDTOConverterLogic {
    func convert(from dto: NewsResponseDTO) -> NewsModel.NewsResponse
}
