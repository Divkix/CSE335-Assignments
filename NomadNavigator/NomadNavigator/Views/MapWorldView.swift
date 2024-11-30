//
//  MapWorldView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI

struct MapWorldView: View { var body: some View { Text("Map World View") } }

#Preview {
    MapWorldView()
        .modelContainer(for: Item.self, inMemory: true)
}

