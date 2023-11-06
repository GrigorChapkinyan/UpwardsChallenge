//
//  IStorageManager.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation

protocol IStorageManager {
    associatedtype LocalType
    associatedtype RemoteType
    
    var isFetchingData: Bool { get }
    var firstDataWasFetched: Bool { get }

    init(localStorage: some ILocalStorage, remoteStorage: some IRemoteStorage)
    
    func remove(_ items: [RemoteType]) async -> Result<Void, Error>
    func add(_ items: [RemoteType]) async -> Result<Void, Error>
    func getItems(predicate: NSPredicate?, sortDescriptor: SortDescriptor<RemoteType>?, limit: Int?) async -> Result<[RemoteType], Error>
}
