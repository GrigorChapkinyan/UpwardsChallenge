//
//  Album.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation
import CoreData

/// Representation of the "Album" model
struct Album: IModelStructObject {
    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artworkIconUrlPath = "artworkUrl100"
        case artistName
        case releaseDate
    }
    
    // MARK: - Private Properties

    var id: String
    var name: String
    var artworkIconUrlPath: String?
    var artistName: String
    var releaseDate: Date
    
    // MARK: - Static Public API

    static func getCorrectDecoderStrategy() -> JSONDecoder.DateDecodingStrategy {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: Constants.Album.Utils.dateFormatterLocaleId.rawValue)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = Constants.Album.Utils.dateFormat.rawValue
        return .formatted(formatter)
    }
    
    // MARK: - IModelStructObject
    
    func getManagedObject(context: NSManagedObjectContext) -> IModelManagedObject {
        let albumMO = AlbumMO(entity: AlbumMO.entity(), insertInto: context)
        
        albumMO.customId = self.id
        albumMO.name = self.name
        albumMO.artworkIconUrlPath = self.artworkIconUrlPath
        albumMO.artistName = self.artistName
        albumMO.releaseDate = self.releaseDate

        return albumMO
    }
}

// MARK: Album + Hashable

extension Album: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(artworkIconUrlPath)
        hasher.combine(artistName)
        hasher.combine(releaseDate)
    }
}

// MARK: - Constants + Album

fileprivate extension Constants {
    struct Album {
        enum Utils: String {
            case dateFormatterLocaleId = "en_US_POSIX"
            case dateFormat = "yyyy-MM-dd"
        }
    }
}
