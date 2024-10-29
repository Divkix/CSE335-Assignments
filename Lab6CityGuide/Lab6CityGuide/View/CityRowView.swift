//
//  CityRowView.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//

import SwiftUI

struct CityRowView: View {
    let city: City

    var body: some View {
        HStack {
            if let image = city.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.trailing, 8)
            } else {
                // Placeholder image if image is not available
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                Text(city.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 2)
    }
}
