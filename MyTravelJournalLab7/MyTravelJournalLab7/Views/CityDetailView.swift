//
//  CityDetailView.swift
//  MyTravelJournalLab7
//
//  Created by Divanshu Chauhan on 11/4/24.
//


import SwiftUI

// view for city detail
struct CityDetailView: View {
    var city: City
    
    var body: some View {
        VStack {
            if let imageData = city.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            Text(city.name)
                .font(.largeTitle)
                .padding()
            Text(city.cityDescription)
                .padding()
            Spacer()
        }
        .navigationBarTitle(city.name, displayMode: .inline)
    }
}
