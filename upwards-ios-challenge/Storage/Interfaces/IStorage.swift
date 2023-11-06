//
//  IStorage.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation

/// This is an abstract interface representing a layer for interacting with a storage.
protocol IStorage {
    associatedtype T
    associatedtype E

    /// Initializes an instance with the provided argument.
    /// - Parameter requestExecutor: "IRequestExecutor" instance to be stored and used for future calls.
    init(with requestExecutor: IRequestExecutor)
    
    /// Retrieve items from a storage filtering with passed predicate, limit and sorting with passed sortDescriptor.
    /// - Returns: Result of the call with fetched items or with error
    func getItems(predicate: NSPredicate?, sortDescriptor: SortDescriptor<T>?, limit: Int?) async -> Result<[T], Error>
    
    /// Removes specific items from a storage by querying with the provided array of IDs.
    /// - Parameter ids: Items to remove
    /// - Returns: Result of the call with sucess or with error
    @discardableResult
    func remove(_ items: [E]) async -> Result<Void, Error>
    
    /// Adds passed items to storage.
    /// - Parameter items: Items to add.
    /// - Returns:  Result of the call with sucess or with error
    @discardableResult
    func addItems(_ items: [E]) async -> Result<Void, Error>
}
