//
//  NetworkManager.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation
import Combine

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
    public static let instance = NetworkManager()
    private let session: URLSession
    private let apiUrl = "https://api.openweathermap.org"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    enum Encoding {
        case json
        case url
    }
    
    func request<Response>(_ endpoint: Endpoint<Response>) -> AnyPublisher<Response, Error> {
        let encoding: Encoding
        switch endpoint.method {
        case .post, .put, .patch:
            encoding = .json
        default:
            encoding = .url
        }
        
        guard var urlComponents = URLComponents(string: apiUrl + endpoint.path.stringValue) else {
            return Fail(error: NetworkError.network).eraseToAnyPublisher()
        }
        
        let apiKeyQueryItem = URLQueryItem(name: "appid", value: "10a177996c09432322a07e4b59cda283")
        
        if encoding == .url {
            if let parameters = endpoint.parameters {
                urlComponents.queryItems = (parameters.map {
                    return URLQueryItem(name: $0.key, value: "\($0.value)")
                } + [apiKeyQueryItem])
            } else {
                urlComponents.queryItems = [apiKeyQueryItem]
            }
        }
        
        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.network).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            request.allHTTPHeaderFields = headers
        }
        
        if let parameters = endpoint.parameters, encoding == .json {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return session.fetchData(request: request)
            .tryMap { data in
                do {
                    return try endpoint.decode(data)
                } catch {
                    throw NetworkError.decoding
                }
            }
            .catch { error -> AnyPublisher<Response, Error> in
                let networkError: NetworkError
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        networkError = .network
                    default:
                        networkError = .network
                    }
                } else {
                    networkError = .network
                }
                print("!!!!! Error \(networkError)")
                return Fail(error: networkError).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension URLSession {
    func fetchData(request: URLRequest) -> AnyPublisher<Data, Error> {
        return Future { promise in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = data {
                    promise(.success(data))
                } else {
                    promise(.failure(NetworkError.network))
                }
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
}
