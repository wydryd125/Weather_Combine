//
//  CityData.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation

struct City: Identifiable, Codable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinates
}

struct Coordinates: Codable, Hashable {
    let lon: CGFloat
    let lat: CGFloat
}
