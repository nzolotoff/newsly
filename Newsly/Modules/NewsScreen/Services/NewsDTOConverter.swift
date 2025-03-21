//
//  NewsDTOConverter.swift
//  Newsly
//
//  Created by Nikita Zolotov on 05.03.2025.
//

import Foundation

struct NewsDTOConverter: NewsDTOConverterLogic {
    func convert(from dto: NewsResponseDTO) -> NewsModel.NewsResponse {
        return NewsModel.NewsResponse(
            news: dto.news.map(convert),
            requestId: dto.requestId ?? ""
        )
    }
    
    private func convert(from dto: ArticleDTO) -> NewsModel.Article {
        return NewsModel.Article(
            id: dto.id,
            title: dto.title,
            announce: dto.announce,
            sourceIcon: URL(string: dto.sourceIcon ?? ""),
            sourceName: dto.sourceName,
            image: dto.image.map(convert)
        )
    }
    
    private func convert(from dto: ArticleImageDTO) -> NewsModel.ArticleImage {
        NewsModel.ArticleImage(
            url: URL(string: dto.url ?? ""),
            isRemote: dto.isRemote
        )
    }
}
