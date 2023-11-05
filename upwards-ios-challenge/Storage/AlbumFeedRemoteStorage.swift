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
    
    func getItems(limit: Int? = 10) async -> Result<[AlbumFeed], Error> {
        let request = HTTPRequest(url: "\(Constants.AlbumFeedRemoteStorage.baseURL.rawValue)\(Constants.AlbumFeedRemoteStorage.mostPlayedAlbumsPath.rawValue)/\(limit ?? 10)\(Constants.AlbumFeedRemoteStorage.mostPlayedAlbumsEndpoint.rawValue)")
        return await self.requestExecutor
            .execute(request)
            .flatMap({ (data) in
                guard let data = data as? Data else {
                    return .failure(AlbumFeedRemoteStorageError.dataDowncastError)
                }
                
                do {
                    let albumFeed = try self.jsonDecoder.decode(AlbumFeed.self, from: data)
                    return .success([albumFeed])
                }
                catch {
                    return .failure(error)
                }
            })
    }
    
    func removeItems(with ids: [String]) async -> Result<Void, Error> {
        return .failure(AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction)
    }
    
    func getItems(with ids: [String]) async -> Result<[AlbumFeed], Error> {
        return .failure(AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction)
    }
    
    func addItems(_ items: [AlbumFeed]) async -> Result<Void, Error> {
        return .failure(AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction)
    }
    
    // MARK: - Private API
    
    private func setupIntialsConfigs() {
        configureDateDecodingStrategy(for: jsonDecoder)
    }
    
    private func configureDateDecodingStrategy(for decoder: JSONDecoder) {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
    }
}

// MARK: - AlbumFeedRemoteStorageError

fileprivate enum AlbumFeedRemoteStorageError: Swift.Error {
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
    enum AlbumFeedRemoteStorage: String {
        case baseURL = "https://rss.applemarketingtools.com"
        case mostPlayedAlbumsPath = "/api/v2/us/music/most-played"
        case mostPlayedAlbumsEndpoint = "/albums.json"
    }
}

