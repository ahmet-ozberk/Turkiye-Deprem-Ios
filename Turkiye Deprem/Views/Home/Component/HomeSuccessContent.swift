//
//  HomeSuccessContent.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 15.01.2025.
//

import SwiftUI

struct HomeSuccessContent: View {
    let depremler: [TurkiyeDepremModel]
    let filteredDepremler: [TurkiyeDepremModel]
    let onRefresh: () async -> Void

    @State private var showScrollToTop: Bool = false
    @State private var visibleItems: Set<Int> = Set()
    @State private var position = ScrollPosition(edge: .top)

    var body: some View {
        if depremler.isEmpty {
            Text(LocalizedStringKey("NotEarthquakeData"))
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
        } else {
            ZStack(alignment: .bottomLeading) {
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(filteredDepremler) { deprem in
                            NavigationLink(
                                destination: DetailView(deprem: deprem)
                                    .navigationBarBackButtonHidden()
                                    .toolbar(.hidden)
                            ) {
                                HomeEarthquakeCard(item: deprem)
                                    .cardTransition()
                                    .id(deprem.id)
                            }.onAppear {
                                visibleItems.insert(deprem.id)
                            }.onDisappear {
                                visibleItems.remove(deprem.id)
                            }
                        }
                    }
                }
                .scrollPosition($position)
                .refreshable {
                    await onRefresh()
                }.animation(
                    .spring(response: 0.3, dampingFraction: 0.7),
                    value: filteredDepremler
                )
                .animation(.default, value: position)
                HStack {
                    NavigationLink(
                        destination: MapEarthquakeView(
                            depremler: filteredDepremler
                        )
                        .navigationBarBackButtonHidden()
                        .toolbar(.hidden)
                    ) {
                        Label(
                            LocalizedStringKey("Map"), systemImage: "map.fill"
                        )
                        .padding()
                        .foregroundStyle(.white)
                        .background(AppColors.primaryColor)
                    }.clipShape(RoundedRectangle(cornerRadius: 12))
                    Spacer()
                    if !visibleItems.contains(filteredDepremler.first?.id ?? -1)
                    {
                        Button(action: { position.scrollTo(edge: .top) }) {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 20, weight: .light))
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(AppColors.primaryColor)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 4)
                        }
                    }
                }
                .padding([.leading, .bottom, .trailing], 16)
            }
        }
    }
}

#Preview {
    HomeView()
}
