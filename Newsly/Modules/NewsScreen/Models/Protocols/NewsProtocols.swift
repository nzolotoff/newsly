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
}

protocol NewsDataStore {
    var articles: [NewsModel.Article] { get }
}

protocol NewsPresentationLogic {
    func presentStart()
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
