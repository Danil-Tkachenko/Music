//
//  AlbumModel.swift
//  Music
//
//  Created by Леонид Шелудько on 20.01.2023.
//

import Foundation

struct AlbumModel: Decodable, Equatable {
    let results: [Album]
    
}

struct Album: Decodable, Equatable {
    let artistName: String
    let collectionName: String
    let artworkUrl100: String?
    let trackCount: Int
    let releaseDate: String
    let collectionId: Int
}
