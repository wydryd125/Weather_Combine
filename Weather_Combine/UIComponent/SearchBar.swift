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
                    .foregroundColor(.gray)
            }
            
            TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                isFocuse = isEditing
                if !isEditing {
                    // 포커스가 해제될 때 키보드를 내림
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
            })
            .id("searchField")
            .focused($isFocuse)
            .padding(8)
            .cornerRadius(8)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            
            if !searchText.isEmpty && isFocuse {
                Button(action: {
                    searchText.removeAll()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.midGrayBlue)
        .cornerRadius(10)
        .shadow(color: Color.midBlue.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}
