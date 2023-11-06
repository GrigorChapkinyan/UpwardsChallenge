//
//  Feed.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation
import CoreData

/// Representation of the "Feed" model
struct Feed: IModelStructObject {
    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case results
    }
    
    // MARK: - Private Properties

    var results: [Album]
    
    // MARK: - IModelStructObject
    
    func getManagedObject(context: NSManagedObjectContext) -> IModelManagedObject {
        let feedMO = FeedMO(entity: FeedMO.entity(), insertInto: context)
        
        let albumManageObjects = results.compactMap({
            let objectIter = $0.getManagedObject(context: context) as? AlbumMO
            objectIter?.feed = feedMO
            return objectIter
        })
        
        (feedMO.results as? NSMutableSet)?.addObjects(from: albumManageObjects)
        
        return feedMO
    }
}
