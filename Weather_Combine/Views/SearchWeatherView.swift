//
//  SearchWeatherView.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import SwiftUI
import Combine

struct SearchWeatherView: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var filteredCities: [City] = []
    
    @ObservedObject var viewModel: CitySearchViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                searchBar
                searchListView
            }
            Spacer(minLength: 40)
        }
        .padding(.horizontal, 16)
        .background(Color.deepBlue)
        .edgesIgnoringSafeArea(.bottom)
        .gesture(
            DragGesture().onChanged { _ in
                isFocused = false
            }
            .simultaneously(with: TapGesture().onEnded {
                UIApplication.shared.endEditing()
            })
        )
        .scrollDismissesKeyboard(.immediately)
    }
    
    private var searchBar: some View {
        HStack {
            Button(action: {
                viewModel.searchQuery = ""
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16))
                    .foregroundColor(.midGrayBlue)
                    .padding(.trailing, 8)
            }
            
            SearchBar(searchText: $viewModel.searchQuery, isSearching: .constant(true))
                .focused($isFocused)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }

    private var searchListView: some View {
        LazyVStack(spacing: 8) {
            ForEach(viewModel.filteredCities) { city in
                VStack(spacing: 8) {
                    Text(city.name)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(city.country)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectCity(city)
                    viewModel.searchQuery = ""
                    dismiss()
                }
                
                Divider()
                    .background(Color.white)
                    .frame(height: 0.4)
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
