//
//  WeatherViewModel.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var weatherForecastData: WeatherForecastData?
    @Published var isLoading: Bool = false
    @Published var selectedCity: City?

    private var cancellables = Set<AnyCancellable>()
    private let repository = WeatherRepository()

    init() {
        bind()
    }

    private func bind() {
        $selectedCity
            .flatMap { [weak self] city -> AnyPublisher<(WeatherData, WeatherForecastData), Error> in
                guard let self = self else {
                    return Empty<(WeatherData, WeatherForecastData), Error>().eraseToAnyPublisher()
                }
                self.isLoading = true
                let coord: Coordinates
                if let city = city {
                    coord = city.coord
                } else {
                    // 기본 좌표 (서울)
                    coord = Coordinates(lon: 126.9780, lat: 37.566)
                }
                
                let weatherPublisher = self.fetchWeather(coord: coord)
                let forecastPublisher = self.fetchForecast(coord: coord)
                
                return Publishers.Zip(weatherPublisher, forecastPublisher)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure(_) = completion {
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] weather, forecast in
                guard let self = self else { return }
                
                self.isLoading = false
                self.weatherData = weather
                self.weatherForecastData = forecast
            })
            .store(in: &cancellables)
    }

    private func fetchWeather(coord: Coordinates) -> AnyPublisher<WeatherData, Error> {
        return Future<WeatherData, Error> { [weak self] promise in
            guard let self = self else { return }
            self.repository.getWeather(coord: coord)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { weather in
                    promise(.success(weather))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }

    private func fetchForecast(coord: Coordinates) -> AnyPublisher<WeatherForecastData, Error> {
        return Future<WeatherForecastData, Error> { [weak self] promise in
            guard let self = self else { return }
            self.repository.getForecast(coord: coord)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { forecast in
                    promise(.success(forecast))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
}
