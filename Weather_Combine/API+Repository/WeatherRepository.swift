//
//  WeatherRepository.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation
import Combine

final class WeatherRepository {
    private let client = NetworkManager()
    
    func getWeather(coord: Coordinates) -> AnyPublisher<WeatherData, Error> {
        client.request(API.getWeather(coord: coord))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func getForecast(coord: Coordinates) -> AnyPublisher<WeatherForecastData, Error> {
        client.request(API.getForecast(coord: coord))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

}
