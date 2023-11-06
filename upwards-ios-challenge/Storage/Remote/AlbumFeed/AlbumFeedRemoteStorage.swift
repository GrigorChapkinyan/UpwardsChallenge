//
//  AlbumFeedRemoteStorage.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/4/23.
//

import Foundation

/// This is a struct representing a layer for interacting with the remote storage of "AlbumFeed" models.
struct AlbumFeedRemoteStorage: IRemoteStorage {
    // MARK: - Private Properties
    
    private let requestExecutor: IRequestExecutor
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - IRemoteStorage
    
    init(with requestExecutor: IRequestExecutor) {
        self.requestExecutor = requestExecutor
        setupIntialsConfigs()
    }
    
    func getItems(predicate: NSPredicate?, sortDescriptor: SortDescriptor<AlbumFeed>?, limit: Int?) async -> Result<[AlbumFeed], Error> {
        let request = HTTPRequest(url: "\(Constants.AlbumFeedRemoteStorage.Endpoints.baseURL.rawValue)\(Constants.AlbumFeedRemoteStorage.Endpoints.mostPlayedAlbumsPath.rawValue)/\(limit ?? 100)\(Constants.AlbumFeedRemoteStorage.Endpoints.mostPlayedAlbumsEndpoint.rawValue)")
        return await self.requestExecutor
            .execute(request)
            .flatMap({ (data) in
                guard let data = data as? Data else {
                    return .failure(AlbumFeedRemoteStorageError.dataDowncastError)
                }
                
                do {
                    let albumFeed = try self.jsonDecoder.decode(AlbumFeed.self, from: data)
                    if let _ = sortDescriptor {
                        // One object :D no sort, just keep the original relationship of entities, to show the work with CoreData
//                        albumFeed.sort(using: sortDescriptor)
                    }
                    return .success([albumFeed])
                }
                catch {
                    return .failure(error)
                }
            })
    }
    
    func remove(_ items: [AlbumFeed]) async -> Result<Void, Error> {
        return .failure(AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction)
    }
    
    func addItems(_ items: [AlbumFeed]) async -> Result<Void, Error> {
        return .failure(AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction)
    }
    
    // MARK: - Private API
    
    private func setupIntialsConfigs() {
        jsonDecoder.dateDecodingStrategy = Album.getCorrectDecoderStrategy()
    }
}

// MARK: - AlbumFeedRemoteStorageError

enum AlbumFeedRemoteStorageError: Swift.Error {
    case noProvidedApiForCurrentAction
    case dataDowncastError
}

extension AlbumFeedRemoteStorageError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .noProvidedApiForCurrentAction:
                return NSLocalizedString("No API is provided for current action.", comment: "")
            case .dataDowncastError:
                return NSLocalizedString("Fail to downcast the data.", comment: "")
        }
    }
}

// MARK: - Constants + AlbumFeedRemoteStorage

fileprivate extension Constants {
    struct AlbumFeedRemoteStorage {
        enum Endpoints: String {
            case baseURL = "https://rss.applemarketingtools.com"
            case mostPlayedAlbumsPath = "/api/v2/us/music/most-played"
            case mostPlayedAlbumsEndpoint = "/albums.json"
        }
    }
}

