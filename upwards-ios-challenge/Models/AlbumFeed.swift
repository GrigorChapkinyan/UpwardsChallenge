//
//  AlbumFeed.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation
import CoreData

/// Representation of the "AlbumFeed" model
struct AlbumFeed: IModelStructObject {
    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case feed
    }
    
    // MARK: - Private Properties

    var feed: Feed
    
    // MARK: - IModelStructObject
    
    func getManagedObject(context: NSManagedObjectContext) -> IModelManagedObject {
        let albumFeedMO = AlbumFeedMO(entity: AlbumFeedMO.entity(), insertInto: context)
        
        albumFeedMO.customId = "hardcodeCustomId"
        albumFeedMO.feed = self.feed.getManagedObject(context: context) as? FeedMO
        albumFeedMO.feed?.albumFeed = albumFeedMO
        
        return albumFeedMO
    }
}
