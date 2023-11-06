//
//  TopAlbumsViewModel.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/6/23.
//

import Foundation

class TopAlbumsViewModel {
    // MARK: - Outut
    
    var itemsReceived: (([TopAlbumCellViewModel]) -> ())?
    var errorReceived: ((Error) -> ())?

    // MARK: - Input
    
    var refresh: (() -> ())? = nil
    
    // MARK: - Private Properties
    
    var items = [TopAlbumCellViewModel]()
    var lastError: Error?
    private let storageManager: AlbumFeedStorageManager<AlbumFeedLocalStorage, AlbumFeedRemoteStorage>
    
    // MARK: - Initializers
    
    init(itemsReceived: (([TopAlbumCellViewModel]) -> Void)?, errorReceived: ((Error) -> ())?) {
        self.itemsReceived = itemsReceived
        self.errorReceived = errorReceived
       
        // Setting storage manager
        let localStorage = AlbumFeedLocalStorage(with: LocalStorageRequestExecutor<AlbumFeedMO, AlbumFeed>())
        let remoteStorage = AlbumFeedRemoteStorage(with: HTTPRequestExecutor())
        let albumFeedStorageManager = AlbumFeedStorageManager<AlbumFeedLocalStorage, AlbumFeedRemoteStorage>(localStorage: localStorage, remoteStorage: remoteStorage)
        self.storageManager = albumFeedStorageManager
        
        // Setting refresh closure
        self.refresh = { [weak self] in
            self?.refreshData()
        }
    }
    
    private func refreshData() {
        Task.detached { [weak self] in
            let result = await self?.storageManager.getItems(predicate: nil, sortDescriptor: nil, limit: nil)
            
            switch result {
                case .success(let albumsFeeds):
                    var albums = [Album]()
                    
                    for albumsFeedIter in albumsFeeds {
                        albums.append(contentsOf: albumsFeedIter.feed.results)
                    }
                    
                    let albumCellViewModels = albums.map({ TopAlbumCellViewModel(album: $0) })
                    self?.items = albumCellViewModels
                
                    await MainActor.run { [weak self] in
                        self?.itemsReceived?(albumCellViewModels)
                    }
                
                case .failure(let error):
                    self?.lastError = error
                    await MainActor.run { [weak self] in
                        self?.errorReceived?(error)
                    }
                default:
                    break
            }
        }
    }
}
