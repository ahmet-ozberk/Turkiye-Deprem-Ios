//
//  AppColors.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

import SwiftUICore

struct AppColors {
    static let backgroundColor = Color(hex: 0xF4F5F8) // Light grayish background
    static let primaryColor = Color(hex: 0x0277BD)    // Bright blue for primary actions
    static let secondaryColor = Color(hex: 0x26A69A)  // Teal for secondary actions
    static let accentColor = Color(hex: 0xFFA726)     // Orange for highlights and accents
    static let errorColor = Color(hex: 0xD32F2F)      // Red for error messages
    static let textColorPrimary = Color(hex: 0x212121) // Dark gray for primary text
    static let textColorSecondary = Color(hex: 0x757575) // Lighter gray for secondary text
    static let buttonTextColor = Color.white           // White for button text
    static let dividerColor = Color(hex: 0xBDBDBD)    // Gray for dividers and outlines
    static let softWhite = Color(hex: 0xF9F9F9)       // Very light gray for backgrounds
    static let lightGray = Color(hex: 0xE0E0E0)       // Light gray for backgrounds
    static let whiteColor = Color.white               // White for backgrounds
    static let cardWhiteColor = Color(hex: 0xFDFEFE)  // Light gray for card backgrounds
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
