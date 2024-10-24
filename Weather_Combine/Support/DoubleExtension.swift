//
//  DoubleExtension.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation

extension Double {
    func getTemperatureString() -> String {
        return String(format: "%.0f°", self - 273.15)
    }
}
