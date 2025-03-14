//
//  Request.swift
//  Newsly
//
//  Created by Nikita Zolotov on 02.03.2025.
//

import Foundation

struct Request {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    var endpoint: Endpoint
    var method: Method
    var parameters: [String: String]?
    var timeoutInterval: TimeInterval
    let body: Data?
    
    init(
        endpoint: Endpoint,
        method: Method = .get,
        parameters: [String : String]? = nil,
        body: Data? = nil,
        timeoutInterval: TimeInterval = 5
    ) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
        self.timeoutInterval = timeoutInterval
        self.body = body
        
        if var endpointParameters = endpoint.parameters {
            for (key, value) in parameters ?? [:] {
                endpointParameters[key] = value
            }
            
            self.parameters = endpointParameters
        }
    }
}
