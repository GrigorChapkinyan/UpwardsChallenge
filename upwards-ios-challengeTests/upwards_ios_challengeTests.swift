//
//  upwards_ios_challengeTests.swift
//  upwards-ios-challengeTests
//
//  Created by Alex Livenson on 11/3/23.
//

import XCTest
@testable import upwards_ios_challenge

final class upwards_ios_challengeTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testITunesAPI() async throws {
        let itunesApi = ITunesAPI(requestExecutor: TestRequestExecutor(dataModelType: .albumFeed))
        let album = try? await itunesApi.getTopAlbums().get().feed.results.first

        XCTAssertEqual(album?.id, "1713845538")
        XCTAssertEqual(album?.name, "1989 (Taylor's Version) [Deluxe]")
        XCTAssertEqual(album?.artworkIconUrlPath, "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/8e/35/6c/8e356cc2-0be4-b83b-d29e-b578623df2ac/23UM1IM34052.rgb.jpg/100x100bb.jpg")
        XCTAssertEqual(album?.artistName, "Taylor Swift")
        XCTAssertEqual(album?.releaseDate.timeIntervalSince1970, 1698364800)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

// MARK: - DataModelType

fileprivate enum DataModelType {
    case albumFeed
}

// MARK: - TestRequestExecutor

fileprivate final class TestRequestExecutor: IRequestExecutor {
    
    // MARK: - Nested Types
    
    enum TestRequestExecutorError: Swift.Error {
        case mockFileNotFound
    }
    
    // MARK: - Private Properties
    
    let dataModelType: DataModelType
    
    // MARK: - Initializers

    init(dataModelType: DataModelType) {
        self.dataModelType = dataModelType
    }
    
    // MARK: - IRequestExecutor
    
    func execute(_ request: upwards_ios_challenge.IRequest) async -> Result<Any, Error> {
        do {
            let data = try getMockDataFileAsData()
            return .success(data)
        }
        catch {
            return .failure(error)
        }
    }
    
    // MARK: - Private API

    private func getMockDataFileAsData() throws -> Data {
        let mockDataFileUrl = try getMockDataFileUrl()
        let fileData = try Data(contentsOf: mockDataFileUrl)
        return fileData
    }
    
    private func getMockDataFileUrl() throws -> URL {
        // Getting file path from the current bundle
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
        let filePath: String?
        
        switch self.dataModelType {
            case .albumFeed:
                filePath = bundle.path(forResource: Constants.upwards_ios_challengeTests.Utils.mockAlbumFeedFileName.rawValue, ofType: Constants.upwards_ios_challengeTests.Utils.mockAlbumFeedFileExt.rawValue)
        }
        
        guard let filePath = filePath else {
            throw TestRequestExecutorError.mockFileNotFound
        }
        
        return URL(fileURLWithPath: filePath)
    }
}

// MARK: - Constants + upwards_ios_challengeTests

fileprivate extension Constants {
    struct upwards_ios_challengeTests {
        enum Utils: String {
            case mockAlbumFeedFileName = "MockAlbumFeed"
            case mockAlbumFeedFileExt = "json"
        }
    }
}
