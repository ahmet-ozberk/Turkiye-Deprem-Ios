//
//  MapEarthquakeViewModel.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 15.01.2025.
//

import Foundation
import MapKit

class MapEarthquakeViewModel: ObservableObject {
    @Published var clusters: [ClusterAnnotation] = []
    let depremler: [TurkiyeDepremModel]
    
    init(depremler: [TurkiyeDepremModel]) {
        self.depremler = depremler
    }
    
    func updateClusters(in region: MKCoordinateRegion?) {
        guard let region = region else { return }
        
        let factor: Double = 100
        let latitudeDelta = region.span.latitudeDelta
        let longitudeDelta = region.span.longitudeDelta
        
        var gridCells: [String: [TurkiyeDepremModel]] = [:]
        
        for deprem in depremler {
            let cellLatitude = Int(deprem.enlem * factor / latitudeDelta)
            let cellLongitude = Int(deprem.boylam * factor / longitudeDelta)
            let key = "\(cellLatitude),\(cellLongitude)"
            
            if var cell = gridCells[key] {
                cell.append(deprem)
                gridCells[key] = cell
            } else {
                gridCells[key] = [deprem]
            }
        }
        
        clusters = gridCells.map { _, depremsInCell in
            let centerLatitude = depremsInCell.map { $0.enlem }.reduce(0, +) / Double(depremsInCell.count)
            let centerLongitude = depremsInCell.map { $0.boylam }.reduce(0, +) / Double(depremsInCell.count)
            return ClusterAnnotation(
                depremler: depremsInCell,
                coordinate: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
            )
        }
    }
}
