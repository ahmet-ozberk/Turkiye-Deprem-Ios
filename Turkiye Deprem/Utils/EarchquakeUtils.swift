//
//  EarchquakeUtils.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

import SwiftUICore

struct EarchquakeUtils {
    static func earthquakeSizeColor(_ size: Double) -> Color {
        switch size {
        case ..<4.0:
            return AppColors.secondaryColor
        case 4.0..<5.0:
            return AppColors.accentColor
        case 5.0..<6.0:
            return AppColors.errorColor
        case 6.0...:
            return Color(red: 0.5, green: 0, blue: 0.5)
        default:
            return AppColors.secondaryColor
        }
    }
}
