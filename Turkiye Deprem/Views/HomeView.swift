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
    @FocusState private var focusState: Bool

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
            deprem.yer.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
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
                }.animation(.easeInOut(duration: 0.3), value: isSearching)
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                switch viewModel.turkiyeDepremState {
                case .loading:
                    LoadingView().frame(alignment: .center)
                case .refresh:
                    LoadingView()
                case .success(let depremler):
                    if depremler.isEmpty {
                        Text("Deprem verisi bulunamadı")
                            .frame(
                                maxWidth: .infinity, maxHeight: .infinity,
                                alignment: .center)
                    } else {
                        ZStack(alignment: .bottomLeading) {
                            ScrollView {
                                LazyVStack(spacing: 2) {
                                    ForEach(filteredDepremler) { deprem in
                                        NavigationLink(
                                            destination: DetailView(
                                                deprem: deprem
                                            )
                                            .navigationBarBackButtonHidden()
                                            .toolbar(.hidden)
                                        ) {
                                            HomeEarthquakeCard(item: deprem)
                                                .transition(
                                                    .asymmetric(
                                                        insertion: .scale(
                                                            scale: 0.95
                                                        )
                                                        .combined(
                                                            with: .opacity),
                                                        removal: .scale(
                                                            scale: 0.95
                                                        )
                                                        .combined(
                                                            with: .opacity)
                                                    )
                                                )
                                                .id(deprem.id)
                                        }
                                    }
                                }
                            }.refreshable {
                                await refresh()
                            }.animation(
                                .spring(response: 0.3, dampingFraction: 0.7),
                                value: searchText)
                            NavigationLink(
                                destination: MapEarthquakeView(depremler: filteredDepremler)
                                    .navigationBarBackButtonHidden()
                                    .toolbar(.hidden)
                            ) {
                                Label("Harita", systemImage: "map.fill")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .background(AppColors.primaryColor)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding([.leading, .bottom], 16)
                        }
                    }

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
