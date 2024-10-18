//
//  Movie.swift
//  TableViewLab5
//
//  Created by Divanshu Chauhan on 10/17/24.
//

import Foundation

struct Movie: Identifiable {
    let id = UUID()
    var name: String
    var genre: String
    var imageName: String
    var description: String
}

