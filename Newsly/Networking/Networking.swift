//
//  Networking.swift
//  Newsly
//
//  Created by Nikita Zolotov on 02.03.2025.
//

import Foundation

protocol NetworkingLogic {
    typealias Response = ((_ response: Result<Networking.ServerResponse, Error>) -> Void)
    
    func execute(with request: Request, completion: @escaping Response)
}

enum Networking {
    struct ServerResponse {
        let data: Data?
        let response: URLResponse?
    }
}

final class BaseURLWorker: NetworkingLogic {
    enum BaseURLError: LocalizedError {
        case invalidRequest
        case invalidResponse
        case badRequest
        case unauthorized
        case notFound
        case serverError
        case someError(statusCode: Int)
        
        var description: String {
            switch self {
            case .invalidRequest:
                return "Invalid request"
            case .invalidResponse:
                return "Invalid responce"
            case .badRequest:
                return "Invalid request"
            case .unauthorized:
                return "Unauthorized"
            case .notFound:
                return "Not found"
            case .serverError:
                return "Server error"
            case .someError(let statusCode):
                return "Error code: \(statusCode)"
            }
        }
    }
    
    var baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func execute(with request: Request, completion: @escaping Response) {
        guard let urlRequest = convert(request) else {
            completion(.failure(BaseURLError.invalidRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(BaseURLError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                completion(.success(Networking.ServerResponse(data: data, response: response)))
            case 400:
                completion(.failure(BaseURLError.badRequest))
            case 404:
                completion(.failure(BaseURLError.notFound))
            case 500...599:
                completion(.failure(BaseURLError.serverError))
            default:
                completion(.failure(BaseURLError.someError(statusCode: httpResponse.statusCode)))
            }
        }.resume()
    }
    
    private func convert(_ request: Request) -> URLRequest? {
        guard let url = generateDestinationURL(for: request) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.endpoint.headers
        urlRequest.httpBody = request.body
        urlRequest.timeoutInterval = request.timeoutInterval
        
        return urlRequest
    }
    
    private func generateDestinationURL(for request: Request) -> URL? {
        guard
            let url = URL(string: baseURL),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }
        
        let queryItems = request.parameters?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        components.path += request.endpoint.compositePath
        components.queryItems = queryItems
        
        return components.url
    }
}
