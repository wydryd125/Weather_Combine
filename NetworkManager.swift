//
//  NetworkManager.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation


enum API {}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case network
    case decoding
}

final class NetworkManager {
 
}
