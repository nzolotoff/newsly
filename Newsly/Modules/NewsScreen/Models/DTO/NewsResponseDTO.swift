//
//  ResponceDTO.swift
//  Newsly
//
//  Created by Nikita Zolotov on 02.03.2025.
//

import Foundation

struct NewsResponseDTO: Decodable {
    let news: [ArticleDTO]
    let requestId: String
}

