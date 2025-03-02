//
//  NewsImageDTO.swift
//  Newsly
//
//  Created by Nikita Zolotov on 02.03.2025.
//

import Foundation

struct ArticleImageDTO: Decodable {
    let isRemote: Bool
    let url: URL 
}
