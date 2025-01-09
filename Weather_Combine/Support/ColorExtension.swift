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
    
    static let darkGray = Color(red: 108, green: 108, blue: 108)
    static let lightGray = Color(red: 216, green: 222, blue: 235)
    static let deepBlue = Color(red: 41, green: 53, blue: 77)
    static let darkBlue = Color(red: 56, green: 73, blue: 104)
}

