//
//  LocationViewModel.swift
//  LocationAppMVVNClassActivity
//
//  Created by Divanshu Chauhan on 9/26/24.
//

import Combine

class LocationViewModel: ObservableObject {
    @Published var location: Location = Location(city: "", state: "")
}
