//
//  AppState.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

enum AppState<T> {
    case loading
    case refresh
    case success(T)
    case error(String)
}
