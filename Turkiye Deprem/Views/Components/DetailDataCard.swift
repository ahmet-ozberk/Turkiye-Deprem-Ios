//
//  DetailDataCard.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 15.01.2025.
//

import SwiftUI

struct DetailDataCard: View {
    let title: String
    let value: String
    let icon: String // SF Symbols icon name
    let iconColor: Color
    let headlineMaxLines: Int
    
    init(
        title: String,
        value: String,
        icon: String,
        iconColor: Color,
        headlineMaxLines: Int = 1
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.iconColor = iconColor
        self.headlineMaxLines = headlineMaxLines
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
                .frame(width: 28, height: 28)
                .overlay(
                    Circle()
                        .stroke(iconColor, lineWidth: 1)
                )
                .padding(6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textColorPrimary)
                    .lineLimit(headlineMaxLines)
                Text(title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppColors.textColorSecondary)
                    .lineLimit(1)
            }.frame(maxWidth: .infinity,alignment: .leading)
        }.frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppColors.cardWhiteColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
