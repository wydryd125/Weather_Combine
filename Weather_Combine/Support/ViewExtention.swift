//
//  ViewExtention.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(when shouldShow: Bool,
                                    alignment: Alignment = .leading,
                                    @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

