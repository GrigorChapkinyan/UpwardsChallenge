//
//  IRemoteStorage.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/4/23.
//

import Foundation

/// This is an abstract interface representing a layer for interacting with remote storage.
protocol IRemoteStorage {
    associatedtype T where T: Decodable
        
    /// Initializes an instance with the provided argument.
    /// - Parameter requestExecutor: "IRequestExecutor" instance to be stored and used for future calls.
    init(with requestExecutor: IRequestExecutor)
    
    /// Retrieve items from a remote source with a specified limit, if it is not nil.
    /// - Parameter limit: The limit specifies the number of items to be retrieved. A remote call will be made without specifying a limit if it is nil.
    /// - Returns: Result of the call with fetched items or with error
    func getItems(limit: Int?) async -> Result<[T], Error>
    
    /// Retrieves specific items from a remote source by querying with the provided array of IDs.
    /// - Parameter ids: IDs to search for
    /// - Returns: Result of the call with fetched items or with error
    func getItems(with ids: [String]) async -> Result<[T], Error>
    
    /// Removes specific items from a remote source by querying with the provided array of IDs.
    /// - Parameter ids: IDs to search for
    /// - Returns: Result of the call with sucess or with error
    func removeItems(with ids: [String]) async -> Result<Void, Error>
    
    /// Adds passed items to remote storage.
    /// - Parameter items: Items to add.
    /// - Returns:  Result of the call with sucess or with error
    func addItems(_ items: [T]) async -> Result<Void, Error>
}
