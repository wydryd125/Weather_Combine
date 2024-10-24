//
//  ColorExtension.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import SwiftUI

extension Color {
    init(red: Int, green: Int, blue: Int, alpha: Double = 1) {
        self.init(red: Double(red) / 255.0,
                  green: Double(green) / 255.0,
                  blue: Double(blue) / 255.0,
                  opacity: alpha)
    }
    
    init(hex: Int, alpha: CGFloat = 1) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let lightBlue = Color(red: 122, green: 160, blue: 208)
    static let midBlue = Color(red: 105, green: 140, blue: 199)
    static let deepBlue = Color(red: 87, green: 124, blue: 183)
    static let midGrayBlue = Color(red: 179, green: 194, blue: 212)
    static let lightGrayBlue = Color(red: 199, green: 214, blue: 222)
}

