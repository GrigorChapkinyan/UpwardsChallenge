//
//  FeedMO.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation
import CoreData

/// Representation of the "FeedMO" model
final class FeedMO: NSManagedObject {}

// MARK: - FeedMO + IModelManagedObject

extension FeedMO: IModelManagedObject {
    func getStructObject() throws -> IModelStructObject {
        guard let resultsSet = results,
              let albumMOArray = resultsSet.allObjects as? [AlbumMO]  else {
            throw IModelManagedObjectError.propertyIsNil
        }
        
        let resultsArray = try albumMOArray.map({ try $0.getStructObject() as! Album })
        let feed = Feed(results: resultsArray)
        
        return feed
    }
    
    static func getEntityName() -> String {
        return "FeedMO"
    }
}
