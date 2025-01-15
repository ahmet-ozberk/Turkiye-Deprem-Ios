//
//  HomeEarthquakeCard.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

import SwiftUI

struct HomeEarthquakeCard: View {
    let item: TurkiyeDepremModel
//    let onItemClick: (TurkiyeDepremModel) -> Void
//    @State private var isPressed = false

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        EarchquakeUtils.earthquakeSizeColor(item.buyukluk)
                            .opacity(0.2)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(
                                EarchquakeUtils.earthquakeSizeColor(
                                    item.buyukluk), lineWidth: 4)
                    )
                    .frame(width: 46, height: 46)

                Text(String(format: "%.1f", item.buyukluk))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(
                        EarchquakeUtils.earthquakeSizeColor(item.buyukluk))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(item.yer)
                    .font(.system(size: 14,weight: .bold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(AppColors.textColorPrimary)
                    .lineLimit(2)

                Text("\(item.tarih) - \(item.saat)")
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(AppColors.textColorSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .light))
                .foregroundColor(AppColors.textColorSecondary)
                .frame(width: 28, height: 28)
        }.padding(.all, 12)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 16)
            .padding(.top, 8)
    }
}

// Preview
struct HomeEarthquakeCard_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        //        let sampleEarthquake = TurkiyeDepremModel(
        //            id: 1,
        //            tarih: "2025-01-13",
        //            saat: "20:40:01",
        //            enlem: 39.0,
        //            boylam: 28.0,
        //            derinlik: 7.0,
        //            buyukluk: 4.2,
        //            yer: "Akhisar, Manisa"
        //        )
        //
        //        HomeEarthquakeCard(
        //            item: sampleEarthquake,
        //            onItemClick: { _ in }
        //        )
        //        .previewLayout(.sizeThatFits)
        //        .padding()
    }
}
