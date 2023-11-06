//
//  TopAlbumCellViewModel.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/6/23.
//

import Foundation

struct TopAlbumCellViewModel {
    // MARK: - Output
    
    let albumName: String
    let singerName: String
    let iconUrlPath: String?
    
    init(album: Album) {
        self.albumName = album.name
        self.iconUrlPath = album.artworkIconUrlPath
        self.singerName = album.artistName
    }
}
