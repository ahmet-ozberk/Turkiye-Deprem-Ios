//
//  Turkiye_DepremApp.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

import SwiftUI
import SwiftData

@main
struct Turkiye_DepremApp: App {
    init() {
        // HTTP isteklerine izin ver
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.register(
                defaults: [
                    "\(bundleIdentifier).NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true
                    ]
                ]
            )
        }
    }
    var body: some Scene {
        WindowGroup {
            HomeView().colorScheme(.light)
        }
    }
}
