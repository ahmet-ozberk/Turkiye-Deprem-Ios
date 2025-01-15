//
//  MapEarthquakeView.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 15.01.2025.
//

import MapKit
import SwiftUI

class ClusterAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let depremler: [TurkiyeDepremModel]

    init(depremler: [TurkiyeDepremModel], coordinate: CLLocationCoordinate2D) {
        self.depremler = depremler
        self.coordinate = coordinate
    }
}

struct MapEarthquakeView: View {
    let depremler: [TurkiyeDepremModel]

    @StateObject private var viewModel: MapEarthquakeViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var initialPosition: MapCameraPosition
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var selectedDeprem: TurkiyeDepremModel?  // Seçili cluster
    @State private var showingDetail: Bool = false  // BottomSheet durumu

    init(depremler: [TurkiyeDepremModel]) {
        _viewModel = StateObject(
            wrappedValue: MapEarthquakeViewModel(depremler: depremler))
        self.depremler = depremler
        _initialPosition = .init(
            initialValue: MapCameraPosition.camera(
                MapCamera(
                    centerCoordinate: CLLocationCoordinate2D(
                        latitude: Constants.trLat, longitude: Constants.trLon),
                    distance: Constants.trDistance,
                    heading: 0,
                    pitch: 0
                )
            ))
    }

    private func markerSize(count: Int) -> CGFloat {
        return CGFloat(12 + (count != 1 ? 18 : 12))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(initialPosition: initialPosition) {
                ForEach(viewModel.clusters) { cluster in
                    Annotation("", coordinate: cluster.coordinate) {
                        ZStack {
                            Circle()
                                .fill(
                                    cluster.depremler.count == 1
                                        ? EarchquakeUtils.earthquakeSizeColor(
                                            cluster.depremler[0].buyukluk)
                                        : AppColors.primaryColor
                                )
                                .frame(
                                    width: markerSize(
                                        count: cluster.depremler.count),
                                    height: markerSize(
                                        count: cluster.depremler.count)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                )

                            if cluster.depremler.count > 1 {
                                Text("\(cluster.depremler.count)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        .onTapGesture {
                            showingDetail = false
                            if cluster.depremler.count == 1 {
                                selectedDeprem = cluster.depremler.first
                                showingDetail = true

                            }
                        }
                    }
                }
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                visibleRegion = context.region
                viewModel.updateClusters(in: context.region)
            }
            .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .center) {
                Rectangle()
                    .clipShape(Circle())
                    .frame(width: 36, height: 36)
                    .foregroundStyle(AppColors.errorColor)
                Image(systemName: "xmark")
                    .foregroundStyle(AppColors.whiteColor)
            }.frame(
                maxWidth: .infinity, maxHeight: .infinity,
                alignment: .topTrailing
            )
            .padding([.top, .trailing], 16)
            .onTapGesture {
                dismiss()
            }
            if showingDetail {
                VStack(alignment: .trailing, spacing: 0) {

                    Image(systemName: "xmark")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .background(AppColors.backgroundColor)
                        .foregroundStyle(AppColors.errorColor)
                        .onTapGesture {
                            showingDetail = false
                            selectedDeprem = nil
                        }

                    EarthquakeDetailCard(deprem: selectedDeprem!)
                }
            }
        }
    }
}

#Preview {
    MapEarthquakeView(depremler: [
        TurkiyeDepremModel(
            id: 1,
            tarih: "2025-01-13",
            saat: "20:40:01",
            enlem: 39.0,
            boylam: 28.0,
            derinlik: 7.0,
            buyukluk: 3.2,
            yer: "Akhisar, Manisa"
        ),
        TurkiyeDepremModel(
            id: 1,
            tarih: "2023-06-43",
            saat: "12:56:23",
            enlem: 38.0,
            boylam: 29.0,
            derinlik: 7.0,
            buyukluk: 3.2,
            yer: "Maraş, Ebistan"
        ),
    ])
}
