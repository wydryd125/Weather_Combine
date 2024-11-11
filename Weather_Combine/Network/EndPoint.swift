//
//  EndPoint.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation

typealias Parameters = [String: Any]

enum Path: ExpressibleByStringLiteral {
    case path(String)

    init(stringLiteral value: String) {
        self = .path(value)
    }
    
    var stringValue: String {
        switch self {
        case .path(let path):
            return path
        }
    }
}

final class Endpoint<Response> {
    let method: HTTPMethod
    let path: Path
    let parameters: Parameters?
    let headers: [String: String]?
    let decode: (Data) throws -> Response

    init(method: HTTPMethod = .get,
         path: Path,
         parameters: Parameters? = nil,
         headers: [String: String]? = nil,
         decode: @escaping (Data) throws -> Response) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.decode = decode
    }
}


extension Endpoint where Response: Decodable {
    convenience init(method: HTTPMethod = .get,
                     path: Path,
                     headers: [String: String]? = nil,
                     parameters: Parameters? = nil) {
        self.init(method: method, path: path, parameters: parameters, headers: headers) { data in
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NSError()
            }
        }
    }
}
