//
//  NewsEndpoint.swift
//  Newsly
//
//  Created by Nikita Zolotov on 04.03.2025.
//

import Foundation

enum NewsEndpoint: Endpoint {
    case news(
        rubricId: Int,
        pageIndex: Int,
        pageSize: Int
    )
    
    var compositePath: String {
        switch self {
        case .news:
            return "/Section"
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var parameters: [String: String] {
        var result: [String: String] = [:]
        
        switch self {
        case let .news(rubricId, pageIndex, pageSize):
            result = [
                "rubricId": "\(rubricId)",
                "pageIndex": "\(pageIndex)",
                "pageSize": "\(pageSize)"
            ]
            return result
        }
    }
}
