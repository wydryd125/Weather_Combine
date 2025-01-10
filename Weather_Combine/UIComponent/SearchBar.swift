//
//  SearchBar.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @FocusState private var isFocuse: Bool
    
    var body: some View {
        HStack {
            if searchText.isEmpty {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.darkGray)
            }
            
            TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                isFocuse = isEditing
                if !isEditing {
                    hideKeyboard()
                }
            })
            .focused($isFocuse)
            .autocorrectionDisabled(true)
            .padding(8)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            
            if !searchText.isEmpty && isFocuse {
                Button(action: {
                    searchText.removeAll()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.darkGray)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .cornerRadius(10)
    }
    
    // 키보드 내리기 함수
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
