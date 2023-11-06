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
    
    // MARK: - AlbumFeedRemoteStorage Tests
    
    func test_AlbumFeedRemoteStorage_RemoveItems_Method() async {
        let albumFeedRemoteStorage = AlbumFeedRemoteStorage(with: TestRequestExecutor(dataModelType: .albumFeed))

        // Testing "func remove([]) async -> Result<Void, Error>" method
        var albumError: Error?
        
        do {
            let _ = try await albumFeedRemoteStorage.remove([]).get()
        }
        catch {
            albumError = error
        }
        
        XCTAssertEqual(albumError as! AlbumFeedRemoteStorageError, AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction)
        XCTAssertEqual(albumError?.localizedDescription, AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction.localizedDescription)
    }
    
    func test_AlbumFeedRemoteStorage_AddItems_Method() async {
        let albumFeedRemoteStorage = AlbumFeedRemoteStorage(with: TestRequestExecutor(dataModelType: .albumFeed))

        // Testing "func addItems(_ items: [AlbumFeed]) async -> Result<Void, Error>" method
        var albumError: Error?
        
        do {
            try await albumFeedRemoteStorage.addItems([AlbumFeed(feed: Feed(results: [Album(id: "Test", name: "Test", artistName: "Tet", releaseDate: Date())]))]).get()
        }
        catch {
            albumError = error
        }
        
        XCTAssertEqual(albumError as! AlbumFeedRemoteStorageError, AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction)
        XCTAssertEqual(albumError?.localizedDescription, AlbumFeedRemoteStorageError.noProvidedApiForCurrentAction.localizedDescription)
    }
    
    func test_AlbumFeedRemoteStorage_For_WrongDataType_ReceiveError() async {
        // Testing the case when "IRequestExecutor" instance will return wrong data type
        let albumFeedRemoteStorageWithWrongDataType = AlbumFeedRemoteStorage(with: TestRequestExecutor(dataModelType: .albumFeed, mustReturnWrongDataType: true))
        var album: Album?
        var albumError: AlbumFeedRemoteStorageError?
        
        do {
            album = try await albumFeedRemoteStorageWithWrongDataType.getItems(predicate: nil, sortDescriptor: nil, limit: nil).get().first?.feed.results.first
        }
        catch {
            albumError = error as? AlbumFeedRemoteStorageError
        }
        
        XCTAssertNil(album)
        XCTAssertEqual(albumError, AlbumFeedRemoteStorageError.dataDowncastError)
        XCTAssertEqual(albumError?.localizedDescription, AlbumFeedRemoteStorageError.dataDowncastError.localizedDescription)
    }
    
    func test_AlbumFeedRemoteStorage_For_InvalidJsonFile_ReceiveError() async {
        // Testing the case when "IRequestExecutor" instance will return invalid JSON file URL
        let albumFeedRemoteStorageWithInvalidJson = AlbumFeedRemoteStorage(with: TestRequestExecutor(dataModelType: .albumFeed, mustReturnInvalidFileUrl: true))
        var album: Album?
        var albumError: Error!
        
        do {
            album = try await albumFeedRemoteStorageWithInvalidJson.getItems(predicate: nil, sortDescriptor: nil, limit: nil).get().first?.feed.results.first
        }
        catch {
            albumError = error
        }
        
        XCTAssertNil(album)
        XCTAssertTrue(albumError is DecodingError)
    }
    
    func testAlbumFeedRemoteStorageWithSuccess() async throws {
        let albumFeedRemoteStorage = AlbumFeedRemoteStorage(with: TestRequestExecutor(dataModelType: .albumFeed))
        
        // Testing "func getItems(limit: Int? = 10) async -> Result<[AlbumFeed], Error>" method with default argument value
        var album: Album?
        var albumError: AlbumFeedRemoteStorageError?
        
        do {
            album = try await albumFeedRemoteStorage.getItems(predicate: nil, sortDescriptor: nil, limit: nil).get().first?.feed.results.first
        }
        catch {
            albumError = error as? AlbumFeedRemoteStorageError
        }
        
        XCTAssertEqual(album?.id, "1713845538")
        XCTAssertEqual(album?.name, "1989 (Taylor's Version) [Deluxe]")
        XCTAssertEqual(album?.artworkIconUrlPath, "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/8e/35/6c/8e356cc2-0be4-b83b-d29e-b578623df2ac/23UM1IM34052.rgb.jpg/100x100bb.jpg")
        XCTAssertEqual(album?.artistName, "Taylor Swift")
        XCTAssertEqual(album?.releaseDate.timeIntervalSince1970, 1698364800)
        XCTAssertNil(albumError)
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
    
    /// The type of the model with which the class will work
    private let dataModelType: DataModelType
    /// Decides wheter a wrong data type must be returned
    private let mustReturnWrongDataType: Bool
    /// Decides wheter an invalid file path URL must be returned
    private let mustReturnInvalidFileUrl: Bool

    // MARK: - Initializers

    init(dataModelType: DataModelType, mustReturnWrongDataType: Bool = false, mustReturnInvalidFileUrl: Bool = false) {
        self.dataModelType = dataModelType
        self.mustReturnWrongDataType = mustReturnWrongDataType
        self.mustReturnInvalidFileUrl = mustReturnInvalidFileUrl
    }
    
    // MARK: - IRequestExecutor
    
    func execute(_ request: upwards_ios_challenge.IRequest) async -> Result<Any, Error> {
        // If "mustReturnWrongDataType" is true, we need to return other data type than "Data", to trigger an specific error
        if mustReturnWrongDataType {
            return .success(Void())
        }
        else {
            do {
                let data = try getMockDataFileAsData()
                return .success(data)
            }
            catch {
                return .failure(error)
            }
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
            // Checking which file must be returned
            let fileName = mustReturnInvalidFileUrl ? Constants.upwards_ios_challengeTests.Utils.mockAlbumFeedInvalidFileName.rawValue : Constants.upwards_ios_challengeTests.Utils.mockAlbumFeedValidFileName.rawValue
                filePath = bundle.path(forResource: fileName, ofType: Constants.upwards_ios_challengeTests.Utils.mockAlbumFeedFileExt.rawValue)
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
            case mockAlbumFeedValidFileName = "MockAlbumFeedValid"
            case mockAlbumFeedInvalidFileName = "MockAlbumFeedInvalid"
            case mockAlbumFeedFileExt = "json"
        } 
    }
}
