//
//  NewsProtocols.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//

protocol NewsBusinessLogic {
    func loadStart()
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
        completion: @escaping (Result<NewsResponseDTO, Error>) -> Void
    )
}

protocol NewsDTOConverterLogic {
    func convert(from dto: NewsResponseDTO) -> NewsModel.NewsResponse
}
