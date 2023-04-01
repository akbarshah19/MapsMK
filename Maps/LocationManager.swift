//
//  LocationManager.swift
//  Maps
//
//  Created by Akbarshah Jumanazarov on 4/1/23.
//

import Foundation
import CoreLocation

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let manager = CLLocationManager()
    
    public func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap { place in
                var name = ""
                
                if let locatoinName = place.name {
                    name += locatoinName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                print("\n\(place)\n\n")
                    
                let result = Location(title: name, coordinates: place.location?.coordinate)
                
                return result
            }
            
            completion(models)
        }
    }
}
