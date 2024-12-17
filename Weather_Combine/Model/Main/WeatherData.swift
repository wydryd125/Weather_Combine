//
//  WeatherData.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation

// MARK: - 날씨
struct WeatherData: Codable, Identifiable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int // 데이터 수집 시간
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int

    
    func getCurWeather() -> String {
        return weather.first?.main ?? "Sunny"
    }
}
