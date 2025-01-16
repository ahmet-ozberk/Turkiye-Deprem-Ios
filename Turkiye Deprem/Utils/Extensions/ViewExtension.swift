//
//  ViewExtension.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 15.01.2025.
//

import SwiftUI

extension View {
    func cardTransition() -> some View {
        self.transition(
            .asymmetric(
                insertion: .scale(scale: 0.95)
                    .combined(with: .opacity),
                removal: .scale(scale: 0.95)
                    .combined(with: .opacity)
            )
        )
    }

    func startWhistle() {
        // Önce bildirim izni iste
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert, .sound, .badge,
        ]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    WhistleService.shared.startWhistle()
                }
            }
        }
    }

    func stopWhistle() {
        WhistleService.shared.stopWhistle()
    }
}
