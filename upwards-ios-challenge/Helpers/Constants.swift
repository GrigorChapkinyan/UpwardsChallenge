//
//  Constants.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/3/23.
//

import Foundation

/// Struct for storing constants and hardcoded strings.
struct Constants {
    enum PersistentContainerNames: String {
        case albumFeed = "AlbumFeed"
    }
    
    static let collectionViewCellMinimumInteritemSpacing = CGFloat(10)
    static let collectionViewCellMinimumLineSpacing = CGFloat(10)
}
