//
//  LoadingView.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 14.01.2025.
//

import Lottie
import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { geometry in
            LottieView(animation: .named("load_lottie"))
                .playing(loopMode: LottieLoopMode.loop)
                .resizable()
                .frame(
                    width: geometry.size.width * 0.5,
                    height: geometry.size.width * 0.5
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    LoadingView()
}
