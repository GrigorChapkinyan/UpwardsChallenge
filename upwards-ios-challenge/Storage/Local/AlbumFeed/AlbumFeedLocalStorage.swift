//
//  AlbumFeedLocalStorage.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation

/// This is a struct representing a layer for interacting with the local storage of "AlbumFeedMO" models.
struct AlbumFeedLocalStorage: ILocalStorage {
    typealias E = AlbumFeed
    typealias T = AlbumFeedMO

    // MARK: - Private Properties
    
    private let requestExecutor: IRequestExecutor
    
    // MARK: - IRemoteStorage
    
    init(with requestExecutor: IRequestExecutor) {
        self.requestExecutor = requestExecutor
    }
    
    func getItems(predicate: NSPredicate?, sortDescriptor: SortDescriptor<AlbumFeedMO>?, limit: Int?) async -> Result<[AlbumFeedMO], Error> {
        let localStorageRequest = LocalStorageRequest<AlbumFeedMO, AlbumFeed>(requestType: .fetch(predicate: predicate, sortDescriptor: sortDescriptor, limit: limit))

        return await requestExecutor.execute(localStorageRequest).map({ $0 as! [AlbumFeedMO] })
    }
    
    func remove(_ items: [AlbumFeed]) async -> Result<Void, Error> {
        let localStorageRequest = LocalStorageRequest<AlbumFeedMO, AlbumFeed>(requestType: .delete(items: items))
        
        return await requestExecutor.execute(localStorageRequest).map({ _ in return () })
    }

    func addItems(_ items: [AlbumFeed]) async -> Result<Void, Error> {
        let localStorageRequest = LocalStorageRequest<AlbumFeedMO, AlbumFeed>(requestType: .add(items: items))

        return await requestExecutor.execute(localStorageRequest).map({ _ in return () })
    }
}

// MARK: - AlbumFeedRemoteStorageError

enum AlbumFeedLocalStorageError: Swift.Error {
}

extension AlbumFeedLocalStorageError: LocalizedError {
    public var errorDescription: String? {
        return nil
    }
}
