//
//  NewsWorker.swift
//  Newsly
//
//  Created by Nikita Zolotov on 04.03.2025.
//

import Foundation

enum NewsServiceError: LocalizedError {
    case noData
    case decodingFailed(Error)
    case networkError(Error)
    case invalidRequest
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No news available"
        case .decodingFailed(let error):
            return "Error ocured while decoding data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidRequest:
            return ""
        }
    }
}

final class NewsService {
    private let networking: NetworkingLogic
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    init(networking: NetworkingLogic) {
        self.networking = networking
    }
    
    // MARK: - Fetch news
    func fetchNews(
        for request: NewsModel.FetchRequest = NewsModel.FetchRequest(
            rubricId: 4,
            pageIndex: 1,
            pageSize: 10
        ),
        completion: @escaping (Result<NewsResponseDTO, Error>) -> Void
    ) {
        let endpoint = NewsEndpoint.news(
            rubricId: request.rubricId,
            pageIndex: request.pageIndex,
            pageSize: request.pageSize
        )
        
        fetch(for: Request(endpoint: endpoint), completion: completion)
    }
 
    // MARK: - Fetch logic
    private func fetch<T: Decodable>(
        for request: Request,
        completion: ((Result<T, Error>) -> Void)?
    ) {
        networking.execute(with: request) { [weak self] response in
            switch response {
            case .success(let serverResponse):
                guard
                    let self,
                    let data = serverResponse.data else {
                    completion?(.failure(NewsServiceError.noData))
                    return
                }
                
                do {
                    let decoded = try self.jsonDecoder.decode(T.self, from: data)
                    completion?(.success(decoded))
                } catch {
                    completion?(.failure(NewsServiceError.decodingFailed(error)))
                }
                
            case .failure(let error):
                if let requestError = error as? BaseURLError {
                    completion?(.failure(NewsServiceError.invalidRequest))
                }
                
                completion?(.failure(NewsServiceError.networkError(error)))
            }
        }
    }
}
