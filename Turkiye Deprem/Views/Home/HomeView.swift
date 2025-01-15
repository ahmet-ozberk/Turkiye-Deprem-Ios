//
//  HomeView.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    @State private var searchText: String = ""
    @State private var isSearching: Bool = false

    init() {
        let repository = RealTurkiyeDepremRepository()
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(turkiyeDepremRepository: repository))
    }

    private var filteredDepremler: [TurkiyeDepremModel] {
        guard case .success(let depremler) = viewModel.turkiyeDepremState else {
            return []
        }

        if searchText.isEmpty {
            return depremler
        }

        return depremler.filter { deprem in
            deprem.yer.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HomeNavigationBar(
                    searchText: $searchText, isSearching: $isSearching)
                switch viewModel.turkiyeDepremState {
                case .loading:
                    LoadingView().frame(alignment: .center)
                case .refresh:
                    LoadingView()
                case .success(let depremler):
                    HomeSuccessContent(
                        depremler: depremler,
                        filteredDepremler: filteredDepremler,
                        onRefresh: refresh
                    )
                case .error(let error):
                    ErrorView(error: error)
                }
            }
            .background(AppColors.backgroundColor)
            .navigationBarBackButtonHidden()
        }.onAppear {
            viewModel.getDepremler()
        }
    }

    private func refresh() async {
        await withCheckedContinuation { continuation in
            viewModel.getDepremler(isRefresh: true) {
                continuation.resume()
            }
        }
    }
}

#Preview {
    HomeView()
}
