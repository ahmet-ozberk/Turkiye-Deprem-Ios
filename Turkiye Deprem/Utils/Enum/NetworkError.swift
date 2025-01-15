//
//  NetworkError.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidData
    case invalidRegex
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidData:
            return "Invalid data received from the server"
        case .invalidRegex:
            return "Invalid regex pattern"
        case .parsingError:
            return "Error parsing the data"
        }
    }
}
