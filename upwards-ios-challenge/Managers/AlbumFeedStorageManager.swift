//
//  AlbumFeedStorageManager.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation

class AlbumFeedStorageManager<L: ILocalStorage, R: IRemoteStorage>: IStorageManager where L.T == AlbumFeedMO, L.E == AlbumFeed, R.T == AlbumFeed {
    // MARK: - Typealias
    
    typealias LocalType = AlbumFeedMO
    typealias RemoteType = AlbumFeed
        
    // MARK: - Public Properties
    
    private(set) var isFetchingData: Bool = false
    private(set) var firstDataWasFetched: Bool = false
    
    // MARK: Private Properties
    
    private let localStorage: L
    private let remoteStorage: R
    private var tasksInProgress = [Task<Any, Never>]()

    // MARK: - Initializers
    
    required init(localStorage: some ILocalStorage, remoteStorage: some IRemoteStorage) {
        self.localStorage = localStorage as! L
        self.remoteStorage = remoteStorage as! R
    }
    
    // MARK: - DeInitializer
    
    deinit {
        tasksInProgress.forEach({ $0.cancel() })
    }
    
    // MARK: - IStorageManager
    
    func remove(_ items: [RemoteType]) async -> Result<(Void), Error> {
        do {
            // First must remove from local storage
            try await localStorage.remove(items).get()
            // Now removing from remote storage
            try await remoteStorage.remove(items).get()
        }
        catch {
            return .failure(error)
        }
        
        return .success(Void())
    }
    
    func add(_ items: [RemoteType]) async -> Result<(Void), Error> {
        do {
            // First must add to local storage
            try await localStorage.addItems(items).get()
            // Now adding to remote storage
            try await remoteStorage.addItems(items).get()
        }
        catch {
            return .failure(error)
        }
        
        return .success(Void())
    }
    
    func getItems(predicate: NSPredicate?, sortDescriptor: SortDescriptor<RemoteType>?, limit: Int?) async -> Result<[RemoteType], Error> {
        defer {
            isFetchingData = false
        }
        

        isFetchingData = true
        var itemsToReturn: [AlbumFeed]!
        
        do {
            // Fetching items from remote
            let remoteItems = try await remoteStorage.getItems(predicate: predicate, sortDescriptor: sortDescriptor, limit: limit).get()
            
            // Saving fetched items in background in another thread
            let task: Task<Any, Never> = Task.detached { [weak self] in
                (try? await self?.localStorage.addItems(remoteItems).get()) ?? Void()
            }
            // Saving reference to have opportunity to cancel in the future if needed
            self.tasksInProgress.append(task)
            
            // Returning items
            itemsToReturn = remoteItems
        }
        catch {
            // Handling no internet case,
            // To get from local
            if let urlError = error as? URLError {
                switch urlError.code {
                    case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost:
                        let storedObjects = try? await localStorage.getItems(predicate: predicate, sortDescriptor: nil, limit: limit).get().compactMap({ try? $0.getStructObject() as? RemoteType })
                        if let storedObjects = storedObjects {
                            itemsToReturn = storedObjects
                        }
                        
                    default:
                        break
                }
            }
            
            // Returning if even coudn't fetch from local db in case of connection error
            if itemsToReturn == nil {
                return .failure(error)
            }
        }
        
        firstDataWasFetched = true
        return .success(itemsToReturn)
    }
}
