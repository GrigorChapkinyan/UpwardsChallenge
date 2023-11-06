//
//  IModelStructObject.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation
import CoreData

protocol IModelStructObject: Codable {
    func getManagedObject(context: NSManagedObjectContext) -> IModelManagedObject
}
