//
//  NewsModels.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//

import Foundation

enum NewsModel {
    struct FetchRequest {
        let rubricId: Int
        let pageIndex: Int
        let pageSize: Int
    }
    
    struct NewsResponse {
        let news: [Article]
        let requestId: String
    }
    
    struct Article {
        let id: Int
        let title: String
        let announce: String
        let sourceIcon: URL?
        let sourceName: String
        let image: ArticleImage?
    }
    
    struct ArticleImage {
        let url: URL?
        let isRemote: Bool
    }
}
