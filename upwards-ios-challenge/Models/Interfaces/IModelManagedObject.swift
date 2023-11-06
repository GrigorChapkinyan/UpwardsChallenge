//
//  IModelManagedObject.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation
import CoreData

// MARK: - IModelManagedObject

protocol IModelManagedObject: NSManagedObject {
    func getStructObject() throws -> IModelStructObject
    static func getEntityName() -> String
    static func getPersistentContainerName() -> String
}

extension IModelManagedObject {
    static func getPersistentContainerName() -> String {
        return Constants.PersistentContainerNames.albumFeed.rawValue
    }
}

// MARK: - IModelManagedObjectError

enum IModelManagedObjectError: Swift.Error {
    case propertyIsNil
}

extension IModelManagedObjectError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .propertyIsNil:
                return "Fail to parse property, because it is nil."
        }
    }
}
