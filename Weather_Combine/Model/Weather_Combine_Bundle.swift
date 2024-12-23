//
//  Weather_Combine_Bundle.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 12/24/24.
//

import Foundation

extension Bundle {
    /// API Key 가져오기
    var apiKey: String {
        guard let path = self.path(forResource: "WeatherInfo", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let propertyList = try? PropertyListSerialization.propertyList(from: xml, format: nil) as? [String: Any],
              let key = propertyList["API_KEY"] as? String else {
            fatalError("API Key가 WeatherInfo.plist에 없습니다.")
        }
        return key
    }
}
