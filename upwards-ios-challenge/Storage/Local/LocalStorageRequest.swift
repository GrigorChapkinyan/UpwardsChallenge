//
//  LocalStorageRequest.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation
import CoreData

struct LocalStorageRequest<T, E>: IRequest where T: IModelManagedObject, E: IModelStructObject {
    // MARK: - Nested Types

    enum RequestType {
        case fetch(predicate: NSPredicate?, sortDescriptor: SortDescriptor<T>?, limit: Int?)
        case update
        case add(items: [E])
        case delete(items: [E])
    }
    
    // MARK: - Private Properties
    
    let requestType: RequestType
    
    // MARK: - Initializers
    
    init(requestType: RequestType) {
        self.requestType = requestType
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        ""
    }
}
