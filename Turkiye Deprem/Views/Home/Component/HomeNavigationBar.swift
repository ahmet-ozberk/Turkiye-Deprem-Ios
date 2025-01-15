//
//  HomeNavigationBar.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 15.01.2025.
//

import SwiftUI

struct HomeNavigationBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @FocusState private var focusState: Bool

    var body: some View {
        HStack {
            Image("transparent_app_logo")
                .resizable()
                .frame(width: 24, height: 24)
            if isSearching {
                TextField(
                    "\(LocalizedStringResource("Search"))...",
                    text: $searchText
                )
                .submitLabel(.search)
                .focused($focusState)
                .textFieldStyle(.roundedBorder)
                .padding(.trailing, 16)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(
                            with: .opacity),
                        removal: .move(edge: .trailing).combined(
                            with: .opacity)
                    ))
            } else {
                Text(LocalizedStringKey("AppName"))
                    .font(.title2)
                    .fontWeight(.light)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .leading)
                                .combined(
                                    with: .opacity),
                            removal: .move(edge: .leading).combined(
                                with: .opacity)
                        ))
            }
            Spacer()
            Button(action: {
                isSearching.toggle()
                focusState = isSearching
                if !isSearching {
                    searchText = ""
                }
            }) {
                Image(
                    systemName: isSearching
                        ? "xmark" : "magnifyingglass"
                )
                .resizable()
                .frame(
                    width: isSearching ? 14 : 18,
                    height: isSearching ? 14 : 18,
                    alignment: .center
                )
                .foregroundStyle(AppColors.textColorPrimary)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isSearching)
        .padding(.horizontal, 16)
        .frame(height: 44)
    }
}
