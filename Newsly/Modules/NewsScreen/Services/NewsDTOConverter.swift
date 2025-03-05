//
//  NewsDTOConverter.swift
//  Newsly
//
//  Created by Nikita Zolotov on 05.03.2025.
//

import Foundation

struct NewsDTOConverter {
    func convert(from dto: NewsResponseDTO) -> NewsModel.NewsResponse {
        return NewsModel.NewsResponse(
            news: dto.news.map(convert),
            requestID: dto.requestID
        )
    }
    
    private func convert(from dto: ArticleDTO) -> NewsModel.Article {
        return NewsModel.Article(
            id: dto.id,
            title: dto.title,
            announce: dto.announce,
            date: dto.date,
            sourceIcon: dto.sourceIcon,
            sourceName: dto.sourceName,
            image: dto.image.map(convert),
            timeOfReading: dto.timeOfReading,
            sectionName: dto.sectionName
        )
    }
    
    private func convert(from dto: ArticleImageDTO) -> NewsModel.ArticleImage {
        NewsModel.ArticleImage(
            url: dto.url,
            isRemote: dto.isRemote
        )
    }
}
