//
//  MainWeatherView.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import SwiftUI
import Combine
import MapKit

struct MainWeatherView: View {
    @State private var isSearching = false
    @State private var searchText = ""
    
    @ObservedObject private var viewModel = MainWeatherViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
            }
        }
    }
}
