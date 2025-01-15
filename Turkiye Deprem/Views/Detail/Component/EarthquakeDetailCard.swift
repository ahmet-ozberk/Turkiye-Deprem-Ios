//
//  EarthquakeDetailCard.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 15.01.2025.
//


import Combine
import MapKit
import SwiftUI

struct EarthquakeDetailCard: View {
    let deprem: TurkiyeDepremModel
    var body: some View {
        VStack(spacing: 4) {
            // Location Card
            DetailDataCard(
                title: "Konum",
                value: deprem.yer,
                icon: "mappin.circle",
                iconColor: AppColors.errorColor,
                headlineMaxLines: 2
            )
            
            // Date and Depth Row
            HStack(spacing: 4) {
                DetailDataCard(
                    title: "Tarih",
                    value: deprem.tarih,
                    icon: "calendar",
                    iconColor: AppColors.primaryColor
                )
                .frame(minWidth: 0, maxWidth: .infinity)
                
                DetailDataCard(
                    title: "Derinlik",
                    value: "\(deprem.derinlik) km",
                    icon: "arrow.down.circle",
                    iconColor: AppColors.secondaryColor
                )
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            
            // Time and Magnitude Row
            HStack(spacing: 4) {
                DetailDataCard(
                    title: "Saat",
                    value: deprem.saat,
                    icon: "clock",
                    iconColor: AppColors.accentColor
                )
                .frame(minWidth: 0, maxWidth: .infinity)
                
                DetailDataCard(
                    title: "Büyüklük",
                    value: String(format: "%.1f", deprem.buyukluk),
                    icon: "waveform.path.ecg",
                    iconColor: AppColors.errorColor
                )
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 16)
        .safeAreaInset(edge: .bottom, content: {
            EmptyView().frame(height: 0)
        })
        .background(AppColors.backgroundColor)
    }
}