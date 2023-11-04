//
//  Album.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

/// Representation of the "Album" model
struct Album: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artworkIconUrlPath = "artworkUrl100"
        case artistName
        case releaseDate
    }
    
    var id: String
    var name: String
    var artworkIconUrlPath: String?
    var artistName: String
    var releaseDate: Date
}
