//
//  AlbumFeedMO.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/3/23.
//

import CoreData

/// Representation of the "AlbumFeed" managed object
final class AlbumFeedMO: NSManagedObject {}

// MARK: - AlbumFeedMO + IModelManagedObject

extension AlbumFeedMO: IModelManagedObject {
    func getStructObject() throws -> IModelStructObject {
        guard let feed = try feed?.getStructObject() as? Feed else {
            throw IModelManagedObjectError.propertyIsNil
        }
        
        let albumFeed = AlbumFeed(feed: feed)
        
        return albumFeed
    }
    
    static func getEntityName() -> String {
        return "AlbumFeedMO"
    }
}
