//
//  ResponceDTO.swift
//  Newsly
//
//  Created by Nikita Zolotov on 02.03.2025.
//

import Foundation

struct NewsResponceDTO: Decodable {
    let news: [ArticleDTO]
    let requestID: String
}
