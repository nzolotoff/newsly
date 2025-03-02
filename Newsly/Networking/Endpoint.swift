//
//  Endpoint.swift
//  Newsly
//
//  Created by Nikita Zolotov on 02.03.2025.
//

import Foundation

protocol Endpoint {
    var compositePath: String { get }
    var headers: [String: String] { get }
    var parameters: [String: String]? { get }
}

extension Endpoint {
    var parameters: [String: String]? {
        return nil
    }
}
