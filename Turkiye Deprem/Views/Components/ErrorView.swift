//
//  ErrorView.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 14.01.2025.
//

import SwiftUI
import Lottie

struct ErrorView: View {
    let error: String?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()
                LottieView(animation: .named("err_lottie"))
                    .playing(loopMode: LottieLoopMode.loop)
                    .resizable()
                    .frame(
                        width: geometry.size.width * 0.5,
                        height: geometry.size.width * 0.5)
                Text(error ?? "Bir hata oluştu")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.backgroundColor)
        }
        .ignoresSafeArea(.keyboard)  // imePadding yerine
    }
}

#Preview {
    ErrorView(error: "Bir sorun oluştu!")
}
