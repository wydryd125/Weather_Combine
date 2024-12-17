//
//  WeatherAPI.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation

extension API {
    static func getWeather(coord: Coordinates) -> Endpoint<WeatherData> {
        let params: [String: Any] = ["lon": coord.lon,
                                     "lat": coord.lat]
        
        return Endpoint(method: .get,
                        path: .path("/data/2.5/weather"),
                        parameters: params
        )
    }
    
    static func getForecast(coord: Coordinates) -> Endpoint<WeatherForecastData> {
        let params: [String: Any] = ["lon": coord.lon,
                                     "lat": coord.lat]
        
        return Endpoint(method: .get,
                        path: .path("/data/2.5/forecast"),
                        parameters: params
        )
    }
}
