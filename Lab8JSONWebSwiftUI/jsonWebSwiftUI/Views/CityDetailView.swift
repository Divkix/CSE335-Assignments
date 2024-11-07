//
//  CityDetailView.swift
//  jsonWebSwiftUI
//
//  Created by Divanshu Chauhan on 11/7/24.
//

import SwiftUI
import MapKit

struct CityDetailView: View {
    var city: City
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lng),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )))
            .edgesIgnoringSafeArea(.all)
        }
        .navigationTitle(city.name)
    }
}
