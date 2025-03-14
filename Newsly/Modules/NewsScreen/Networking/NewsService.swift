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
    case networkError(URLError)
    case invalidRequest
    
    var errorDescription: String {
        switch self {
        case .noData:
            return "No news available"
        case .decodingFailed(let error):
            return "Error ocured while decoding data: \(error.localizedDescription)"
        case .networkError(let urlError):
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection. Please check your network settings."
            case .timedOut:
                return "The request timed out. Please try again later."
            case .cannotFindHost:
                return "Unable to find the server. Please check the URL or try again later."
            case .cannotConnectToHost:
                return "Failed to connect to the server. Please check your connection."
            case .networkConnectionLost:
                return "The network connection was lost. Please try again."
            case .badServerResponse:
                return "The server returned an invalid response. Please try again later."
            default:
                return "An unknown network error occurred. Please try again."
            }
        case .invalidRequest:
            return ""
        }
    }
}

final class NewsService: NewsWorkerLogic {
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
        completion: ((Result<NewsResponseDTO, Error>) -> Void)?
    ) {
        let endpoint = NewsEndpoint.news(
            rubricId: request.rubricId,
            pageIndex: request.pageIndex,
            pageSize: request.pageSize
        )
        
        let request = Request(endpoint: endpoint)
        
        fetch(for: request, completion: completion)
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
                if let _ = error as? BaseURLError {
                    completion?(.failure(NewsServiceError.invalidRequest))
                }
                
                if let urlError = error as? URLError {
                    completion?(.failure(NewsServiceError.networkError(urlError)))
                }
            }
        }
    }
}
