//
//  ITunesAPI.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

/// <#Description#>
struct ITunesAPI {
    // MARK: - Private Properties
     
    private let requestExecutor: IRequestExecutor
    private let jsonDecoder: JSONDecoder

    // MARK: - Initializers
    
    init(requestExecutor: IRequestExecutor = HTTPRequestExecutor(), jsonDecoder: JSONDecoder = JSONDecoder()) {
        // Storing properties
        self.requestExecutor = requestExecutor
        self.jsonDecoder = jsonDecoder
        
        // Doing inital configurations
        setupIntialsConfigs()
    }
    
    // MARK: - Public API

    func getTopAlbums(limit: Int = 10) async -> Result<AlbumFeed, Error> {
        return await Task.detached {
            let request = HTTPRequest(url: "\(Constants.ITunesAPI.baseURL.rawValue)\(Constants.ITunesAPI.mostPlayedAlbumsPath.rawValue)/\(limit)\(Constants.ITunesAPI.mostPlayedAlbumsEndpoint.rawValue)")
            return await self.requestExecutor
                .execute(request)
                .flatMap({ (data) in
                    guard let data = data as? Data else {
                        return .failure(ITunesAPIError.dataDowncastError)
                    }
                    
                    do {
                        let albumFeed = try self.parseAlbumFeed(from: data)
                        return .success(albumFeed)
                    }
                    catch {
                        return .failure(error)
                    }
                })
        }.value
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
    
    private func parseAlbumFeed(from data: Data) throws -> AlbumFeed {
        return try jsonDecoder.decode(AlbumFeed.self, from: data)
    }
}

// MARK: -  ITunesAPIError

enum ITunesAPIError: Swift.Error {
    case dataDowncastError
}

extension ITunesAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .dataDowncastError:
                return NSLocalizedString("Fail to downcast the data.", comment: "")
        }
    }
}

// MARK: - Constants + ITunesAPI

fileprivate extension Constants {
    enum ITunesAPI: String {
        case baseURL = "https://rss.applemarketingtools.com"
        case mostPlayedAlbumsPath = "/api/v2/us/music/most-played"
        case mostPlayedAlbumsEndpoint = "/albums.json"
    }
}
