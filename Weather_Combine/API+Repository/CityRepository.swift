//
//  CityRepository.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation
import Combine

enum CityRepositoryError: Error {
    case invalidURL
    case decodingError
}

final class CityRepository {
    var cities = [City]()
    
    func loadCities() -> AnyPublisher<[City], Error> {
        Future<[City], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(CityRepositoryError.invalidURL))
                return
            }
            
            guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
                promise(.failure(CityRepositoryError.invalidURL))
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let cities = try decoder.decode([City].self, from: data)
                self.cities = cities.filter { $0.name.count > 1 }.sorted { $0.name < $1.name }
                promise(.success(self.cities))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
