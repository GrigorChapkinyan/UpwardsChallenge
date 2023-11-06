//
//  AlbumMO.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation
import CoreData

// MARK: - AlbumMO

/// Representation of the "AlbumMO" model
final class AlbumMO: NSManagedObject {}

// MARK: - AlbumFeedMO + IModelManagedObject

extension AlbumMO: IModelManagedObject {
    func getStructObject() throws -> IModelStructObject {
        guard let customId = customId,
              let name = name,
              let artworkIconUrlPath = artworkIconUrlPath,
              let artistName = artistName,
              let releaseDate = releaseDate  else {
            throw IModelManagedObjectError.propertyIsNil
        }
        
        let album = Album(id: customId, name: name, artworkIconUrlPath: artworkIconUrlPath, artistName: artistName, releaseDate: releaseDate)
        return album
    }
    
    static func getEntityName() -> String {
        return "AlbumMO"
    }
}


