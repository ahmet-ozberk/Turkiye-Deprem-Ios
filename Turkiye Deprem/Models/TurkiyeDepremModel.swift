//
//  TurkiyeDepremModel.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

struct TurkiyeDepremModel: Identifiable, Equatable {
    let id: Int
    let tarih: String
    let saat: String
    let enlem: Double
    let boylam: Double
    let derinlik: Double
    let buyukluk: Double
    let yer: String
}
