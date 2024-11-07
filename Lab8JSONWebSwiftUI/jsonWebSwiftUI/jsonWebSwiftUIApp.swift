//
//  jsonWebSwiftUIApp.swift
//  jsonWebSwiftUI
//
//  Created by Divanshu Chauhan on 11/7/24.
//

import SwiftUI

@main
struct jsonWebSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            CityListView()
        }
    }
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView()
    }
}
