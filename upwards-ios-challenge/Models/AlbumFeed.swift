//
//  AlbumFeed.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/3/23.
//

import Foundation

/// Representation of the "AlbumFeed" model
struct AlbumFeed: Decodable {
    /// Representation of the "Feed" model
    struct Feed: Decodable {
        var results: [Album]
    }
    
    var feed: Feed
}
