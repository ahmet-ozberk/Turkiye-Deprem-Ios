//
//  DetailView.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 14.01.2025.
//

import Combine
import MapKit
import SwiftUI

struct DetailView: View {
    let deprem: TurkiyeDepremModel
    let lat: Double
    let long: Double

    @Environment(\.dismiss) private var dismiss

    @State private var markerLocation: CLLocationCoordinate2D
    @State private var initialPosition: MapCameraPosition
    @State private var visibleRegion: MKCoordinateRegion?

    init(deprem: TurkiyeDepremModel) {
        self.deprem = deprem
        self.lat = deprem.enlem
        self.long = deprem.boylam

        _markerLocation = .init(
            initialValue: .init(latitude: self.lat, longitude: self.long))

        _initialPosition = .init(
            initialValue: MapCameraPosition.camera(
                MapCamera(
                    centerCoordinate: CLLocationCoordinate2D(
                        latitude: lat, longitude: long),
                    distance: 125000,
                    heading: 0,
                    pitch: 0
                )
            ))
    }

    func calcCircleSize(index: Int, scale: Double) -> CGFloat {
        let baseSize = 60 + (Double(index) * Double((20 + (index * 2))))
        return baseSize * scale
    }

    func getZoomScale() -> Double {
        guard let region = visibleRegion else { return 1.0 }
        let baseSpan: Double = 0.4  // Temel zoom seviyesi
        let currentSpan =
            (region.span.latitudeDelta + region.span.longitudeDelta) / 2
        let scale = baseSpan / currentSpan
        return min(max(scale, 0.2), 1.0)  // Scale'i 0.2 ile 1.0 arasında sınırla
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.backward")
                        .foregroundStyle(AppColors.textColorPrimary)
                }
                Text("Deprem Detayı")
                    .font(.title2)
                    .fontWeight(.light)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(.ultraThinMaterial)
            Map(initialPosition: initialPosition) {
                Marker("Deprem Konumu", coordinate: markerLocation)
                    .tint(AppColors.errorColor)

                Annotation("", coordinate: markerLocation) {
                    ZStack {
                        ForEach(0..<6) { index in
                            Circle()
                                .fill(
                                    AppColors.errorColor.opacity(
                                        0.3 - (Double(index) * 0.05))
                                )
                                .frame(
                                    width: calcCircleSize(
                                        index: index, scale: getZoomScale()),
                                    height: calcCircleSize(
                                        index: index, scale: getZoomScale())
                                )
                        }
                    }
                    .offset(y: -10)
                }
            }
            .onMapCameraChange(frequency: .continuous) { context in
                visibleRegion = context.region
            }
            .edgesIgnoringSafeArea(.all)
            EarthquakeDetailCard(deprem: deprem)
        }
    }
}

#Preview {
    DetailView(
        deprem:
            TurkiyeDepremModel(
                id: 1,
                tarih: "2025-01-13",
                saat: "20:40:01",
                enlem: 39.0,
                boylam: 28.0,
                derinlik: 7.0,
                buyukluk: 4.2,
                yer: "Akhisar, Manisa"
            )
    )
}


